import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../l10n/app_localizations.dart';
import '../providers/report_bundle_providers.dart';

/// Bundled-font bytes cached for the lifetime of the app so repeated report
/// generation does not re-read assets.
class _PdfFonts {
  pw.Font? tinos;
  pw.Font? tinosBold;
  pw.Font? nastaleeq;

  bool get ready =>
      tinos != null && tinosBold != null && nastaleeq != null;

  Future<void> load() async {
    if (ready) return;
    final tinosData = await rootBundle.load('assets/fonts/Tinos-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Tinos-Bold.ttf');
    final urduData = await rootBundle.load(
      'assets/fonts/NooriNastaleeq-Regular.ttf',
    );
    tinos = pw.Font.ttf(tinosData);
    tinosBold = pw.Font.ttf(boldData);
    nastaleeq = pw.Font.ttf(urduData);
  }
}

/// Builds bilingual (Urdu Nastaleeq + English) ibadah report PDFs.
///
/// Urdu text uses the bundled Jameel Noori Nastaleeq; English uses Tinos
/// (metric-compatible with Times New Roman). Text is laid out right-to-left
/// for the Urdu variant and left-to-right for English.
class PdfReportService {
  PdfReportService();

  final _PdfFonts _fonts = _PdfFonts();

  /// Palette shared with the app theme.
  static const _emerald = PdfColor.fromInt(0xFF1F8F4E);
  static const _gold = PdfColor.fromInt(0xFFD9B75B);
  static const _ivory = PdfColor.fromInt(0xFFFBFBF7);

  /// Generates a bilingual report PDF and returns its bytes.
  Future<Uint8List> build({
    required ReportBundle bundle,
    required List<ReportRow> rows,
    required AppLocalizations l10n,
    bool urduFirst = true,
  }) async {
    await _fonts.load();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: _fonts.tinos,
        bold: _fonts.tinosBold,
        fontFallback: [_fonts.nastaleeq!],
      ),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        textDirection: urduFirst ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        header: (context) => _header(context, l10n, urduFirst),
        footer: (context) => _footer(context, l10n),
        build: (context) => [
          _metaBlock(l10n, bundle),
          pw.SizedBox(height: 14),
          _summaryTable(l10n, rows),
          pw.SizedBox(height: 18),
          _chart(l10n, rows),
          pw.SizedBox(height: 18),
          _noteBlock(l10n, bundle),
        ],
      ),
    );

    return doc.save();
  }

  /// Opens the platform print/preview dialog for the generated report.
  Future<void> printReport({
    required ReportBundle bundle,
    required List<ReportRow> rows,
    required AppLocalizations l10n,
    bool urduFirst = true,
  }) async {
    await Printing.layoutPdf(
      name: 'ibadah_report_${bundle.rangeLabel}',
      onLayout: (format) => build(
        bundle: bundle,
        rows: rows,
        l10n: l10n,
        urduFirst: urduFirst,
      ),
    );
  }

  /// Shares the generated report as a PDF file.
  Future<void> shareReport({
    required ReportBundle bundle,
    required List<ReportRow> rows,
    required AppLocalizations l10n,
    bool urduFirst = true,
  }) async {
    final bytes = await build(
      bundle: bundle,
      rows: rows,
      l10n: l10n,
      urduFirst: urduFirst,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'ibadah_report_${bundle.rangeLabel}.pdf',
    );
  }

  // ── Layout blocks ───────────────────────────────────────────────────────

  pw.Widget _header(
    pw.Context context,
    AppLocalizations l10n,
    bool urduFirst,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _gold, width: 2),
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            l10n.reportsBismillah,
            style: pw.TextStyle(
              font: _fonts.nastaleeq,
              fontSize: 20,
              color: _emerald,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            l10n.reportsTitleHeading,
            style: pw.TextStyle(
              font: urduFirst ? _fonts.nastaleeq : _fonts.tinosBold,
              fontSize: 16,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _footer(pw.Context context, AppLocalizations l10n) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _gold, width: 1)),
      ),
      child: pw.Text(
        '${l10n.appName} · ${l10n.reportsGeneratedOn} '
        '${_formatDate(DateTime.now())} · ${context.pageNumber}/${context.pagesCount}',
        style: pw.TextStyle(font: _fonts.tinos, fontSize: 9, color: PdfColors.grey700),
      ),
    );
  }

  pw.Widget _metaBlock(AppLocalizations l10n, ReportBundle bundle) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _ivory,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _gold),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${l10n.reportsPeriod}: ${bundle.rangeLabel}',
            style: pw.TextStyle(font: _fonts.tinos, fontSize: 11),
          ),
          pw.Text(
            '${l10n.reportsGeneratedOn}: ${_formatDate(bundle.generatedAt)}',
            style: pw.TextStyle(font: _fonts.tinos, fontSize: 11),
          ),
        ],
      ),
    );
  }

  pw.Widget _summaryTable(AppLocalizations l10n, List<ReportRow> rows) {
    if (rows.isEmpty) {
      return pw.Text(
        l10n.reportsNoDataForRange,
        style: pw.TextStyle(font: _fonts.nastaleeq, fontSize: 14),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.reportsSummaryTable,
          style: pw.TextStyle(font: _fonts.tinosBold, fontSize: 13),
        ),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.6),
          headerDecoration: const pw.BoxDecoration(color: _emerald),
          headerStyle: pw.TextStyle(
            color: PdfColors.white,
            font: _fonts.tinosBold,
            fontSize: 10,
          ),
          cellStyle: pw.TextStyle(font: _fonts.tinos, fontSize: 10),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
          headers: [
            l10n.reportsModuleColumn,
            l10n.reportsDoneColumn,
            l10n.reportsTotalColumn,
            l10n.reportsPercentColumn,
          ],
          data: [
            for (final row in rows)
              [
                '${row.labelEn} / ${row.labelUr}',
                row.done.toString(),
                row.total.toString(),
                '${row.percent}%',
              ],
          ],
        ),
      ],
    );
  }

  pw.Widget _chart(AppLocalizations l10n, List<ReportRow> rows) {
    final visible = rows.where((r) => r.percent > 0 || r.total > 0).toList();
    if (visible.isEmpty) return pw.SizedBox.shrink();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.reportsSummaryTable,
          style: pw.TextStyle(font: _fonts.tinosBold, fontSize: 13),
        ),
        pw.SizedBox(height: 8),
        for (final row in visible)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 120,
                  child: pw.Text(
                    row.labelEn,
                    style: pw.TextStyle(font: _fonts.tinos, fontSize: 9),
                  ),
                ),
                pw.Expanded(
                  child: pw.Stack(
                    children: [
                      pw.Container(
                        height: 12,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey300,
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                      ),
                      pw.Container(
                        height: 12,
                        width: (row.percent.clamp(0, 100) / 100) * 320,
                        decoration: pw.BoxDecoration(
                          color: _emerald,
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 40,
                  child: pw.Text(
                    '${row.percent}%',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(font: _fonts.tinosBold, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _noteBlock(AppLocalizations l10n, ReportBundle bundle) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _ivory,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _gold),
      ),
      child: pw.Text(
        l10n.quote,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: _fonts.nastaleeq, fontSize: 13, color: _emerald),
      ),
    );
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day-$month-${d.year}';
  }
}
