// ignore: file_names
// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:application_principal/Blocks/alert_box.dart';
import 'package:application_principal/database/company_model.dart';
import 'package:application_principal/database/contenu_bon.dart';
import 'package:application_principal/database/track_cpt_achat.dart';
import 'package:application_principal/database/versement_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      String adresse,
      LogoCompany comp,
      CommandeDetaile comDetail,
      ClientAdress client,
      String clientTel,
      List<ContenuCom> comList,
      ResumerFacture resumeFact,
      String user) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      build: (context) => [
        Container(
          height: 80,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          comp.sigle,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(comp.compName,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(height: 5),
                        Text(comp.adresse),
                      ]),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //   Text("Date: "),
                              //   Text("..............."),
                            ]),
                      ]),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Client: ${client.name}, ${client.adresse}',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center),
                      ]),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Numéro de facture: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(comDetail.factureNum),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date d'établissement: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(comDetail.factureDate.split(' ')[0]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Paiement: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                comDetail.payType.isNotEmpty
                                    ? comDetail.payType.join(",")
                                    : 'Credit',
                                style: TextStyle(
                                    fontSize: comDetail.payType.length >= 2
                                        ? 10
                                        : 11)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tel client: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(clientTel),
                          ],
                        ),
                        Divider()
                      ]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Table.fromTextArray(
            headers: [
              'Désignation',
              'Quantitée',
              'Prix unitaire',
              'Prix Total'
            ],
            data: comList.map((e) {
              return [
                e.designation,
                e.qtsProd,
                e.prixUnit,
                (int.parse(e.prixUnit) * double.parse(e.qtsProd))
                    .toStringAsFixed(2)
              ];
            }).toList(),
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 0.9, color: PdfColors.grey100)),
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 15,
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
              2: Alignment.centerRight,
              3: Alignment.centerRight,
            }),
        Divider(thickness: 0.1),
        SizedBox(height: 5),
        Row(children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${resumeFact.total} Fcfa '),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Versée: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${resumeFact.paye} Fcfa '),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Reste: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${resumeFact.rest} Fcfa '),
              ]),
              SizedBox(height: 2),
              Divider(height: 0.5)
            ]),
          )
        ]),
        SizedBox(height: 35),
        Row(children: [
          Expanded(
              child: Column(
                children: [
                  Text('Le vendeur'),
                  SizedBox(height: 10),
                  Text(user, style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              flex: 1),
          Spacer(flex: 4),
          Expanded(child: Text('Le Client'), flex: 1)
        ])
      ],
      footer: (context) => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(thickness: 0.2),
            Center(
              child: Text(adresse,
                  style: TextStyle(), overflow: TextOverflow.clip),
            ),
          ],
        ),
      ),
    ));

    return saveDocument(
        name: "Facture${comDetail.factureNum}.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// impression de bon de sortite

class PdfBonApi {
  static Future<File> generate(
      String adresse,
      LogoCompany comp,
      CommandeDetaile comDetail,
      ClientAdress client,
      List<ContenuBon> comList,
      ResumerFacture resumeFact,
      String user,
      String livraire,
      String type) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        build: (context) => [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comp.sigle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(comp.compName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(comp.adresse),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //   Text("Date: "),
                                //   Text("..............."),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('$type: ${client.name}, ${client.adresse}',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center),
                        ]),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Numéro de facture: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(comDetail.factureNum),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Date d'établissement: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(comDetail.factureDate),
                            ],
                          ),
                          Divider()
                        ]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Table.fromTextArray(
              headers: [
                'Désignation',
                'Quantité',
              ],
              data: comList.map((e) {
                return [
                  e.prod_nom_bon_ctn,
                  e.qts_ctn,
                ];
              }).toList(),
              border: TableBorder(
                  horizontalInside:
                      BorderSide(width: 0.9, color: PdfColors.grey100)),
              headerStyle: TextStyle(fontWeight: FontWeight.bold),
              headerDecoration: BoxDecoration(color: PdfColors.grey300),
              cellHeight: 15,
              cellAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.centerRight,
                2: Alignment.centerRight,
                3: Alignment.centerRight,
              }),
          Divider(thickness: 0.1),
          SizedBox(height: 5),
          Row(children: [
            Spacer(flex: 6),
            Expanded(
              flex: 4,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                type.toLowerCase() != 'boutique'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text('Somme ajoutée: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${resumeFact.total} Fcfa '),
                          ])
                    : Text(''),
              ]),
            )
          ]),
          SizedBox(height: 35),
          Row(children: [
            Expanded(
                child: Column(
                  children: [
                    Text('Le vendeur'),
                    SizedBox(height: 10),
                    Text(user, style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                flex: 1),
            Spacer(flex: 4),
            Expanded(
                child: Column(
                  children: [
                    Text('Le livraire'),
                    SizedBox(height: 10),
                    Text(livraire,
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                flex: 1)
          ])
        ],
        footer: (context) => Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(thickness: 0.2),
              Center(
                child: Text(adresse,
                    style: TextStyle(), overflow: TextOverflow.clip),
              ),
            ],
          ),
        ),
      ),
    );

    return saveDocument(
        name: "Bon_de_sortie${comDetail.factureNum}.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// Impression d'une facture de versement
class PdfVersementApi {
  static Future<File> generate(
    LogoCompany comp,
    String client,
    String deposant,
    ResumerFacture resume,
    String user,
  ) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        build: (context) => [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comp.sigle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(comp.compName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(comp.adresse),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //   Text("Date: "),
                                //   Text("..............."),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Text('Client: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(client,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      flex: 5),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Type Facture: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Versement"),
                              ],
                            ),
                            Divider()
                          ]),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 25),
          Table.fromTextArray(
            headers: [
              'Somme Versée',
              'Somme totale',
              'Date',
            ],
            data: [
              [
                '${resume.paye} FCFA',
                '${int.parse(resume.total) + int.parse(resume.paye)} FCFA',
                resume.rest,
              ]
            ],
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.center,
              2: Alignment.center,
            },
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 0.9, color: PdfColors.grey100)),
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 15,
          ),
          SizedBox(height: 25),
          Row(children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Deposant: ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      Text(deposant,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
            Spacer(flex: 4),
            Expanded(
                child: Column(
                  children: [
                    Text('Le vendeur'),
                    SizedBox(height: 10),
                    Text(user, style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                flex: 1),
          ])
        ],
      ),
    );

    return saveDocument(name: "Versement.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// Impression de resume de versement
class PdfVersementResumeApi {
  static Future<File> generate(
    LogoCompany comp,
    String client,
    List<VersementModel> detailVersList,
  ) async {
    int total = 0;
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        build: (context) => [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comp.sigle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(comp.compName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(comp.adresse),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //   Text("Date: "),
                                //   Text("..............."),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Text('Client: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(client,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      flex: 5),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Type Facture: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Détail versement"),
                              ],
                            ),
                            Divider()
                          ]),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 25),
          Table.fromTextArray(
            headers: [
              'Deposant',
              'Tel',
              'Versée',
              'Totale',
              'Date',
              'Agent',
            ],
            data: detailVersList.map((e) {
              total += int.parse(e.somme_vers);
              return [
                e.nom_vers,
                e.tel_vers,
                e.somme_vers,
                total.toString(),
                e.date_vers,
                e.user_vers
              ];
            }).toList(),
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.center,
              2: Alignment.center,
              3: Alignment.center,
              4: Alignment.center,
              5: Alignment.center,
            },
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 0.9, color: PdfColors.grey100)),
            headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 15,
            cellStyle: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 25),
          Row(children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Etat du compte',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      Text("Fermé",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
            Spacer(flex: 4),
            Expanded(
                child: Column(
                  children: [
                    Text('Montant total'),
                    SizedBox(height: 10),
                    Text("$total Fcfa",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                flex: 1),
          ])
        ],
      ),
    );

    return saveDocument(name: "Versement.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// Impression de relevé de compte de versement
class PdfReleveComptApi {
  static Future<File> generate(
    LogoCompany comp,
    String client,
    List<TrackCpt> trackVersement,
    List<VersementModel> retraiList,
  ) async {
    int totalTrack = 0;
    int totalRetrait = 0;
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        build: (context) => [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comp.sigle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(comp.compName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(comp.adresse),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //   Text("Date: "),
                                //   Text("..............."),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Text('Client: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(client,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      flex: 5),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Type Facture: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Rélévé de compte"),
                              ],
                            ),
                            Divider()
                          ]),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.all(7),
            width: double.infinity,
            color: PdfColors.grey100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rapport des versements'),
                SizedBox(height: 15),
                retraiList.isEmpty
                    ? Center(child: Text("Aucun versement trouvé"))
                    : Table.fromTextArray(
                        headers: [
                          'Date',
                          'Montant',
                          'Agent',
                        ],
                        data: retraiList.map((e) {
                          totalRetrait += int.parse(e.somme_vers);
                          return [
                            e.date_vers,
                            '${e.somme_vers} Fcfa',
                            e.user_vers
                          ];
                        }).toList(),
                        cellAlignments: {
                          0: Alignment.bottomLeft,
                          1: Alignment.bottomLeft,
                          2: Alignment.center,
                        },
                        border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 0.9, color: PdfColors.grey100)),
                        headerStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        headerDecoration:
                            BoxDecoration(color: PdfColors.grey300),
                        cellHeight: 15,
                        cellStyle: TextStyle(fontSize: 12),
                      ),
                SizedBox(height: 25),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Text('Etat du compte',
                            //     style: TextStyle(
                            //       fontSize: 12,
                            //     ),
                            //     textAlign: TextAlign.center),
                            // SizedBox(height: 10),
                            // Text("Fermé",
                            //     style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                    ),
                  ),
                  Spacer(flex: 4),
                  Expanded(
                      child: Column(
                        children: [
                          Text('Montant total'),
                          SizedBox(height: 10),
                          Text("$totalRetrait Fcfa",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      flex: 1),
                ])
              ],
            ),
          ),
          SizedBox(height: 25),
          Container(
            padding: EdgeInsets.all(7),
            width: double.infinity,
            color: PdfColors.grey200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rapport des commandes'),
                SizedBox(height: 15),
                trackVersement.isEmpty
                    ? Center(child: Text("Aucune commande trouvée"))
                    : Table.fromTextArray(
                        headers: [
                          'Date',
                          'Montant',
                          'Agent',
                        ],
                        data: trackVersement.map((e) {
                          totalTrack += int.parse(e.somme);
                          return [e.dateCom, '${e.somme} Fcfa', e.agent];
                        }).toList(),
                        cellAlignments: {
                          0: Alignment.bottomLeft,
                          1: Alignment.bottomLeft,
                          2: Alignment.center,
                        },
                        border: TableBorder(
                            horizontalInside: BorderSide(
                                width: 0.9, color: PdfColors.grey100)),
                        headerStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                        headerDecoration:
                            BoxDecoration(color: PdfColors.grey300),
                        cellHeight: 15,
                        cellStyle: TextStyle(fontSize: 12),
                      ),
                SizedBox(height: 25),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Text('Etat du compte',
                            //     style: TextStyle(
                            //       fontSize: 12,
                            //     ),
                            //     textAlign: TextAlign.center),
                            // SizedBox(height: 10),
                            // Text("Fermé",
                            //     style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                    ),
                  ),
                  Spacer(flex: 4),
                  Expanded(
                      child: Column(
                        children: [
                          Text('Montant total'),
                          SizedBox(height: 10),
                          Text("$totalTrack Fcfa",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      flex: 1),
                ])
              ],
            ),
          ),
          SizedBox(height: 25),
          Text("Resumé"),
          Divider(),
          Container(
            width: 400,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Text('Total Versement',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 7),
                        Text("$totalRetrait Fcfa")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Text('Total commande',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 7),
                        Text("$totalTrack Fcfa")
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Text('Somme disponible',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 7),
                        Text("${totalRetrait - totalTrack} Fcfa")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return saveDocument(name: "rapportCompte.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// Impression d'une facture de paiement credit
class PdfCreditApi {
  static Future<File> generate(
    LogoCompany comp,
    String client,
    String deposant,
    String totalVerse,
    String reste,
    String nume,
    ResumerFacture resume,
    String user,
  ) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        build: (context) => [
          Container(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            comp.sigle,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(comp.compName,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(comp.adresse),
                        ]),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Text("Date: "),
                                // Text(resume.rest),
                              ]),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Text('Client: ',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(client,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      flex: 5),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Type Facture: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Crédit"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Num: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(nume),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Facture: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("${resume.total} FCFA"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Crédit: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("${int.parse(totalVerse) + int.parse(reste)} FCFA"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(resume.rest),
                              ],
                            ),
                            Divider()
                          ]),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 25),
          Table.fromTextArray(
            headers: [
              'Somme Versée',
              'Total Versée',
              'Reste',
            ],
            data: [
              [
                '${resume.paye} FCFA',
                '${int.parse(totalVerse) + int.parse(resume.paye)} FCFA',
                '${int.parse(reste) - (int.parse(resume.paye))} FCFA',
              ]
            ],
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.center,
              2: Alignment.center,
            },
            border: TableBorder(
                horizontalInside:
                    BorderSide(width: 0.9, color: PdfColors.grey100)),
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 15,
          ),
          SizedBox(height: 25),
          Row(children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Deposant: ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 10),
                      Text(deposant,
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
            Spacer(flex: 4),
            Expanded(
                child: Column(
                  children: [
                    Text('Le vendeur'),
                    SizedBox(height: 10),
                    Text(user, style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                flex: 1),
          ])
        ],
      ),
    );

    return saveDocument(name: "Versement.pdf", pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future onpenFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
