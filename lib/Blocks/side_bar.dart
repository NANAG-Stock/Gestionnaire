// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'package:application_principal/redux/actions.dart';
import 'package:application_principal/redux/app_state.dart';
import 'package:application_principal/Blocks/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SideBar extends StatefulWidget {
  final String droit;
  const SideBar({Key? key, required this.droit}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Map<String, dynamic> homeClik = const {
    'home': true,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> prodClik = const {
    'home': false,
    'produit': true,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> stockClik = const {
    'home': false,
    'produit': false,
    'stock': true,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> fourClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': true,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> clientClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': true,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> achatClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': true,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> emploiClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': true,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> venteClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': true,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> bonClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': true,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> inventClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': true,
    'comptabilite': false,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> comptaClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': true,
    'parametre': false,
    'produit_use': false,
  };
  Map<String, dynamic> paramClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': true,
    'produit_use': false,
  };
  Map<String, dynamic> prodUseClik = const {
    'home': false,
    'produit': false,
    'stock': false,
    'fournisseur': false,
    'client': false,
    'achat': false,
    'emploie': false,
    'vente': false,
    'bon_de_sortie': false,
    'inventaire': false,
    'comptabilite': false,
    'parametre': false,
    'produit_use': true,
  };
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    state.company!.logo_com.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              widget.droit.toUpperCase() == "ADMIN"
                  ? Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Links(
                          name: 'Tableau de bord',
                          icone: Icons.palette_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: homeClik));
                            Navigator.pushNamed(context, 'home');
                          },
                          isClicked: state.sideBarElements!['home'],
                        ),
                        Links(
                          name: 'Produits',
                          icone: Icons.article_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: prodClik));
                            Navigator.pushNamed(context, 'produits');
                          },
                          isClicked: state.sideBarElements!['produit'],
                        ),
                        Links(
                          name: 'Stock',
                          icone: Icons.store_mall_directory_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: stockClik));
                            Navigator.pushNamed(context, 'stock');
                          },
                          isClicked: state.sideBarElements!['stock'],
                        ),
                        Links(
                          name: 'Fournisseur',
                          icone: Icons.local_shipping_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: fourClik));
                            Navigator.pushNamed(context, 'fournisseur');
                          },
                          isClicked: state.sideBarElements!['fournisseur'],
                        ),
                        Links(
                          name: 'Clients',
                          icone: Icons.family_restroom_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: clientClik));
                            Navigator.pushNamed(context, 'client');
                          },
                          isClicked: state.sideBarElements!['client'],
                        ),
                        Links(
                          name: 'Achats',
                          icone: Icons.shopping_basket_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: achatClik));
                            Navigator.pushNamed(context, 'achat');
                          },
                          isClicked: state.sideBarElements!['achat'],
                        ),
                        Links(
                          name: 'Employées',
                          icone: Icons.family_restroom_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: emploiClik));
                            Navigator.pushNamed(context, 'employee');
                          },
                          isClicked: state.sideBarElements!['emploie'],
                        ),
                        Links(
                          name: 'Ventes',
                          icone: Icons.sell_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: venteClik));
                            Navigator.pushNamed(context, 'vente');
                          },
                          isClicked: state.sideBarElements!['vente'],
                        ),
                        Links(
                          name: 'Bon de sortie',
                          icone: Icons.add_shopping_cart_rounded,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: bonClik));
                            Navigator.pushNamed(context, 'bon');
                          },
                          isClicked: state.sideBarElements!['bon_de_sortie'],
                        ),
                        Links(
                          name: 'Inventaire',
                          icone: Icons.auto_stories,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: inventClik));
                            Navigator.pushNamed(context, 'inventaire');
                          },
                          isClicked: state.sideBarElements!['inventaire'],
                        ),
                        Links(
                          name: 'Comptabilités',
                          icone: Icons.pie_chart_outline_rounded,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: comptaClik));
                            Navigator.pushNamed(context, 'comptabilite');
                          },
                          isClicked: state.sideBarElements!['comptabilite'],
                        ),
                        Links(
                          name: 'Paramètre',
                          icone: Icons.manage_accounts,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: paramClik));
                            Navigator.pushNamed(context, 'compte');
                          },
                          isClicked: state.sideBarElements!['parametre'],
                        ),
                        Links(
                          name: 'Produits Usés',
                          icone: Icons.folder_delete_outlined,
                          redirect: () {
                            StoreProvider.of<AppState>(context).dispatch(
                                SideBarAction(sidebarElements: prodUseClik));
                            Navigator.pushNamed(context, 'produit_use');
                          },
                          isClicked: state.sideBarElements!['produit_use'],
                        ),
                      ],
                    )
                  : widget.droit.toUpperCase() == "SECRET1"
                      ? Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Links(
                              name: 'Clients',
                              icone: Icons.family_restroom_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: clientClik));
                                Navigator.pushNamed(context, 'Secre1client');
                              },
                              isClicked: state.sideBarElements!['client'],
                            ),
                            Links(
                              name: 'Ventes',
                              icone: Icons.sell_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: venteClik));
                                Navigator.pushNamed(context, 'Secre1vente');
                              },
                              isClicked: state.sideBarElements!['vente'],
                            ),
                            Links(
                              name: 'Comptabilités',
                              icone: Icons.pie_chart_outline_rounded,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: comptaClik));
                                Navigator.pushNamed(
                                    context, 'Secre1comptabilite');
                              },
                              isClicked: state.sideBarElements!['comptabilite'],
                            ),
                            Links(
                              name: 'Produits',
                              icone: Icons.article_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: prodClik));
                                Navigator.pushNamed(context, 'Secre1prod');
                              },
                              isClicked: state.sideBarElements!['produit'],
                            ),
                            Links(
                              name: 'Fournisseur',
                              icone: Icons.local_shipping_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: fourClik));
                                Navigator.pushNamed(context, 'Secre1four');
                              },
                              isClicked: state.sideBarElements!['fournisseur'],
                            ),
                            Links(
                              name: 'Stock',
                              icone: Icons.store_mall_directory_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: stockClik));
                                Navigator.pushNamed(context, 'Secre1stock');
                              },
                              isClicked: state.sideBarElements!['stock'],
                            ),
                            Links(
                              name: 'Achats',
                              icone: Icons.shopping_basket_outlined,
                              redirect: () {
                                StoreProvider.of<AppState>(context).dispatch(
                                    SideBarAction(sidebarElements: achatClik));
                                Navigator.pushNamed(context, 'Secre1com');
                              },
                              isClicked: state.sideBarElements!['achat'],
                            ),
                          ],
                        )
                      : widget.droit.toUpperCase() == "SECRET2"
                          ? Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Links(
                                  name: 'Bon de sortie',
                                  icone: Icons.add_shopping_cart_rounded,
                                  redirect: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SideBarAction(
                                            sidebarElements: bonClik));
                                    Navigator.pushNamed(context, 'Secre2bon');
                                  },
                                  isClicked:
                                      state.sideBarElements!['bon_de_sortie'],
                                ),
                                Links(
                                  name: 'Clients',
                                  icone: Icons.family_restroom_outlined,
                                  redirect: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SideBarAction(
                                            sidebarElements: clientClik));
                                    Navigator.pushNamed(
                                        context, 'Secre2client');
                                  },
                                  isClicked: state.sideBarElements!['client'],
                                ),
                                Links(
                                  name: 'Ventes',
                                  icone: Icons.sell_outlined,
                                  redirect: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SideBarAction(
                                            sidebarElements: venteClik));
                                    Navigator.pushNamed(context, 'Secre2vente');
                                  },
                                  isClicked: state.sideBarElements!['vente'],
                                ),
                                Links(
                                  name: 'Comptabilités',
                                  icone: Icons.pie_chart_outline_rounded,
                                  redirect: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SideBarAction(
                                            sidebarElements: comptaClik));
                                    Navigator.pushNamed(
                                        context, 'Secre2comptabilite');
                                  },
                                  isClicked:
                                      state.sideBarElements!['comptabilite'],
                                ),
                                Links(
                                  name: 'Stock',
                                  icone: Icons.store_mall_directory_outlined,
                                  redirect: () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SideBarAction(
                                            sidebarElements: stockClik));
                                    Navigator.pushNamed(context, 'Secre2stock');
                                  },
                                  isClicked: state.sideBarElements!['stock'],
                                ),
                              ],
                            )
                          : widget.droit.toUpperCase() == "CAISSE"
                              ? Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Links(
                                      name: 'Ventes',
                                      icone: Icons.sell_outlined,
                                      redirect: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SideBarAction(
                                                sidebarElements: venteClik));
                                        Navigator.pushNamed(
                                            context, 'Caisse_vente');
                                      },
                                      isClicked:
                                          state.sideBarElements!['vente'],
                                    ),
                                    Links(
                                      name: 'Dépenses',
                                      icone: Icons.pie_chart_outline_rounded,
                                      redirect: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SideBarAction(
                                                sidebarElements: comptaClik));
                                        Navigator.pushNamed(
                                            context, 'Caisse_comptabilite');
                                      },
                                      isClicked: state
                                          .sideBarElements!['comptabilite'],
                                    ),
                                    Links(
                                      name: 'Bon de sortie',
                                      icone: Icons.add_shopping_cart_rounded,
                                      redirect: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SideBarAction(
                                                sidebarElements: bonClik));
                                        Navigator.pushNamed(
                                            context, 'Casse_bon_de_sortie');
                                      },
                                      isClicked: state
                                          .sideBarElements!['bon_de_sortie'],
                                    ),
                                  ],
                                )
                              : Column(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    // Links(
                                    //   name: 'Produits',
                                    //   icone: Icons.article_outlined,
                                    //   redirect: () => Navigator.pushNamed(
                                    //       context, 'maga_produits'),
                                    // ),

                                    Links(
                                      name: 'Stock',
                                      icone:
                                          Icons.store_mall_directory_outlined,
                                      redirect: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SideBarAction(
                                                sidebarElements: stockClik));
                                        Navigator.pushNamed(
                                            context, 'maga_stock');
                                      },
                                      isClicked:
                                          state.sideBarElements!['stock'],
                                    ),
                                    // Links(
                                    //   name: 'Fournisseur',
                                    //   icone: Icons.local_shipping_outlined,
                                    //   redirect: () => Navigator.pushNamed(
                                    //       context, 'maga_fournisseur'),
                                    // ),
                                    // Links(
                                    //   name: 'Achats',
                                    //   icone: Icons.shopping_basket_outlined,
                                    //   redirect: () => Navigator.pushNamed(
                                    //       context, 'maga_achat'),
                                    // ),
                                    Links(
                                      name: 'Ventes',
                                      icone: Icons.sell_outlined,
                                      redirect: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(SideBarAction(
                                                sidebarElements: venteClik));
                                        Navigator.pushNamed(
                                            context, 'maga_vente');
                                      },
                                      isClicked:
                                          state.sideBarElements!['vente'],
                                    ),
                                  ],
                                ),
            ],
          );
        });
  }
}
