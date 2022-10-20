/// Represents the XlsIO widget class.
import 'dart:io';
import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/database/credit_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExportExcell {
  static Future<void> exportCreditExcel({
    required List<CreditModel> creditList,
    required String title,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    sheet.enableSheetCalculations();
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('A1:H1').cellStyle.backColor = "#26345d";
    sheet.getRangeByName('A1:H1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:H1').cellStyle.fontSize = 18;
    sheet.getRangeByName('A1:H1').cellStyle.bold = true;
    sheet.setRowHeightInPixels(1, 40);
    sheet.getRangeByName('A2:H2').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A2:H2').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A2:H2').cellStyle.fontSize = 12;
    sheet.getRangeByName('A2:H2').cellStyle.backColor = "#bec4c3";
    sheet.getRangeByName('A2:H2').cellStyle.bold = true;
    sheet.setRowHeightInPixels(2, 30);
    sheet.getRangeByName('A1').setText(title);
    sheet.getRangeByName('A1:H1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1:H1').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A1:Z1').columnWidth = 25.0;

    List<Object> headers = [
      'Facture',
      'Nom client',
      'Total crédit',
      'Somme payée',
      'Reste',
      'Date crédit',
      'Téléphone',
      'Agent'
    ];
    DateFormat dFormat = DateFormat("yyyy-MM-dd");
    List<dynamic> rows = [];
    for (var element in creditList) {
      List<dynamic> rowsContent = [];
      rowsContent.addAll([
        ConfirmBox().numFacture(element.dateCred.split('-')[0], element.nume),
        element.nom,
        (int.parse(element.paye) + int.parse(element.reste)),
        int.parse(element.paye),
        int.parse(element.reste),
        dFormat.parse(element.dateCred.split(" ")[0]),
        element.client_tel,
        element.agent
      ]);
      rows.add(rowsContent);
    }
    sheet.importList(headers, 2, 1, false);

    for (var i = 0; i < rows.length; i++) {
      sheet.importList(rows[i], i + 3, 1, false);
    }
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:H104876');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    DateTime date = DateTime.now();
    final String path = (await getApplicationDocumentsDirectory()).path;
    await Directory("$path\\FichierCredits").create(recursive: true);
    String dateFormat = date.toString().split(" ")[0];
    String dateFormat2 = date.toString().split(" ")[1].split(":").join("_");
    final String fileName =
        '$path/FichierCredits/$title(date_exporte_$dateFormat ${dateFormat2.split(".")[0]}).xlsx';
    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  static Future<void> exportAllCreditExcel({
    required List<CreditModel> creditList,
    required String title,
  }) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    sheet.enableSheetCalculations();
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('A1:H1').cellStyle.backColor = "#26345d";
    sheet.getRangeByName('A1:H1').cellStyle.fontColor = "#ffffff";
    sheet.getRangeByName('A1:H1').cellStyle.bold = true;
    sheet.getRangeByName('A1:H1').cellStyle.fontSize = 18;
    sheet.setRowHeightInPixels(1, 40);
    sheet.getRangeByName('A2:H2').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A2:H2').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A2:H2').cellStyle.fontSize = 12;
    sheet.getRangeByName('A2:H2').cellStyle.backColor = "#bec4c3";
    sheet.getRangeByName('A2:H2').cellStyle.bold = true;
    sheet.setRowHeightInPixels(2, 30);
    sheet.getRangeByName('A1').setText(title);
    sheet.getRangeByName('A1:H1').cellStyle.hAlign = HAlignType.center;
    sheet.getRangeByName('A1:H1').cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByName('A1:Z1').columnWidth = 25.0;

    List<Object> headers = [
      'Facture',
      'Nom client',
      'Total crédit',
      'Somme payée',
      'Reste',
      'Date crédit',
      'Téléphone',
      'Agent'
    ];

    List<dynamic> rows = [];
    DateFormat dFormat = DateFormat("yyyy-MM-dd");
    for (var element in creditList) {
      List<dynamic> rowsContent = [];
      rowsContent.addAll([
        int.parse(element.is_manual) == 1
            ? element.fact_num
            : ConfirmBox()
                .numFacture(element.dateCred.split('-')[0], element.nume),
        element.nom.split("-=/")[0],
        (int.parse(element.paye) + int.parse(element.reste)),
        int.parse(element.paye),
        int.parse(element.reste),
        dFormat.parse(element.dateCred.split(" ")[0]),
        element.client_tel,
        element.agent
      ]);
      rows.add(rowsContent);
    }
    sheet.importList(headers, 2, 1, false);

    for (var i = 0; i < rows.length; i++) {
      // print(rows[i][4]);
      // if (rows[i][4] == 0) {
      //   String range = "A" + (i + 3).toString() + ":H" + (i + 3).toString();
      //   sheet.getRangeByName(range).cellStyle.backColor = "#00ff00";
      //   sheet.getRangeByName(range).cellStyle.fontColor = "#ffffff";
      // }
      sheet.importList(rows[i], i + 3, 1, false);
    }
    sheet.autoFilters.filterRange = sheet.getRangeByName('A2:H104876');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    DateTime date = DateTime.now();
    final String path = (await getApplicationDocumentsDirectory()).path;
    await Directory("$path\\FichierCredits").create(recursive: true);

    String dateFormat = date.toString().split(" ")[0];
    String dateFormat2 = date.toString().split(" ")[1].split(":").join("_");
    // File('FichierCredit/text.txt').create(recursive: true);
    final String fileName =
        '$path/FichierCredits/$title(date_exporte_$dateFormat ${dateFormat2.split(".")[0]}).xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}
