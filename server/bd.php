<?php

try {
    $connect = new PDO("mysql:host=localhost;dbname=shop_manager", "g_stock@2022", "G-s(2022-8-10)@DK", [PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8", PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]);
    $action = verifyData($_POST['action']);

    //  connection des utilisateurs
    if ($action == 'connect') {
        $table_name = verifyData($_POST['table_name']);
        $username = verifyData($_POST['card_id']);
        $password = verifyData($_POST['password']);
        $select = $connect->prepare("SELECT * FROM $table_name WHERE username=? AND Mot_passe_user=? AND is_active=1");

        $select->execute([$username, md5($password)]);
        if ($select->rowCount() == 1) {
            $ans = $select->fetch();
            $response = [
                array(
                    'status' => strval(1),
                    'droit' => $ans['Droit_user'],
                    'id_user' => strval($ans['Id_user']),
                    'is_active' => strval($ans['is_active']),
                    'nom' => strval($ans['Nom']),
                    'username' => strval($ans['username']),
                )
            ];
        } else {
            $response = [
                array(
                    'status' => '0',
                    'droit' => '0',
                    'id_user' => '0',
                    'is_active' => '0',
                    'nom' => '0',
                    'username' => '0',
                )
            ];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //ajout d'un utilisateur
    if ($action == 'ajoutEmp') {
        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $cnib = ucfirst(verifyData($_POST['cnib']));
        $salaire = ucfirst(verifyData($_POST['salaire']));
        $droit = ucfirst(verifyData($_POST['droit']));
        $sexe = ucfirst(verifyData($_POST['sexe']));
        $tel = ucfirst(verifyData($_POST['tel']));
        $pw = md5(pw($cnib));

        $checkEmp = $connect->query("SELECT * FROM $table_name WHERE Card_id='" . $cnib . "' AND Droit_user='" . $droit . "' AND is_active=0");
        if ($checkEmp->rowCount() == 0) {
            $ajoutEmp = $connect->prepare("INSERT INTO $table_name(Nom,username, tel_user, Sexe, Card_id, salaire,Mot_passe_user,L_connect, Droit_user,date_user) VALUES(?,?,?,?,?,?,NOW(),?,NOW())");
            if ($ajoutEmp->execute([$nom, $cnib, $tel, $sexe, $cnib, $salaire, $pw, $droit])) {
                echo '1-' . pw($cnib) . '-' . $cnib;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Modifier le username
    if ($action == 'updUserName') {
        $table_name = verifyData($_POST['table_name']);
        $id = intval(verifyData($_POST['id']));
        $username = verifyData($_POST['username']);

        $checkEmp = $connect->query("SELECT * FROM $table_name WHERE Id_user='" . $id . "' AND is_active=1");
        if ($checkEmp->rowCount() == 1) {
            $updEmp = $connect->prepare("UPDATE user SET username=? WHERE Id_user=?");
            if ($updEmp->execute([$username, $id])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Modifier le code
    if ($action == 'addCode') {
        $table_name = verifyData($_POST['table_name']);
        $id = intval(verifyData($_POST['id']));
        $code = verifyData($_POST['code']);

        $checkEmp = $connect->query("SELECT * FROM $table_name WHERE Id_user='" . $id . "' AND is_active=1");
        if ($checkEmp->rowCount() == 1) {
            $updEmp = $connect->prepare("UPDATE user SET code_user=? WHERE Id_user=?");
            if ($updEmp->execute([$code, $id])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // Modifier le mot de passe
    if ($action == 'updPassword') {
        $table_name = verifyData($_POST['table_name']);
        $id = intval(verifyData($_POST['id']));
        $oldPass = md5(verifyData($_POST['oldPass']));
        $newPass = md5(verifyData($_POST['newPass']));

        $checkEmp = $connect->query("SELECT * FROM $table_name WHERE Id_user='" . $id . "' AND Mot_passe_user='" . $oldPass . "' AND is_active=1");
        if ($checkEmp->rowCount() == 1) {
            $updEmp = $connect->prepare("UPDATE user SET Mot_passe_user=? WHERE Id_user=?");
            if ($updEmp->execute([$newPass, $id])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // modifier employee
    if ($action == 'updEmp') {
        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $cnib = ucfirst(verifyData($_POST['cnib']));
        $salaire = ucfirst(verifyData($_POST['salaire']));
        $droit = ucfirst(verifyData($_POST['droit']));
        $sexe = ucfirst(verifyData($_POST['sexe']));
        $tel = ucfirst(verifyData($_POST['tel']));
        $idEmp = intval(verifyData($_POST['idEmp']));

        $checkEmp = $connect->query("SELECT * FROM $table_name WHERE Card_id='" . $cnib . "' AND Droit_user='" . $droit . "' AND is_active=0 AND Id_user !='" . $idEmp . "'");
        if ($checkEmp->rowCount() == 0) {
            $ajoutEmp = $connect->prepare("UPDATE $table_name SET Nom=?, tel_user=?, Sexe=?, Card_id=?, salaire=?, Droit_user=? WHERE Id_user=?");
            if ($ajoutEmp->execute([$nom, $tel, $sexe, $cnib, $salaire, $droit, $idEmp])) {
                echo '1';
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //suppression d'un employee
    if ($action == "delUser") {
        $idEmp = intval(verifyData($_POST['idEmp']));
        $table_name = verifyData($_POST['table_name']);
        $delCat = $connect->prepare("UPDATE $table_name SET is_active=? WHERE Id_user='" . $idEmp . "'");
        if ($delCat->execute([0])) {
            echo '1';
        } else {
            echo '0';
        }
        $connect = null;
        return;
    }
    // Liste de employee
    if ($action == "getEmp") {
        $table_name = verifyData($_POST['table_name']);
        $type = verifyData($_POST['type']);
        $id = verifyData($_POST['id']);
        if ($type == "all") {
            $getProd = $connect->query("SELECT * FROM $table_name em, salaire sa WHERE em.is_active=1 AND em.salaire = sa.id_sa ORDER BY em.Id_user DESC");
        } else {
            $getProd = $connect->query("SELECT * FROM $table_name em, salaire sa WHERE em.is_active=1 AND em.salaire = sa.id_sa AND em.Id_user='" . $id . "' ORDER BY em.Id_user DESC");
        }
        if ($getProd->rowCount() > 0) {
            $response = [];
            $i = 0;

            while ($data = $getProd->fetch()) {
                $response[$i] = array(
                    'nomEmp' => $data['Nom'],
                    'cnibEmp' => $data['Card_id'],
                    'telEmp' => $data['tel_user'],
                    'sexe' => $data['Sexe'],
                    'motdepassEmp' => $data['Mot_passe_user'],
                    'codeEmp' => $data['code_user'],
                    'statutEmp' => $data['is_active'],
                    'idEmp' => $data['Id_user'],
                    'salaireEmp' => $data['val_sa'] . '-' . $data['id_sa'],
                    'droitEmp' => $data['Droit_user'],
                    'dateUser' => $data['date_user'],
                    'dateUser' => $data['date_user'],
                    'username' => $data['username'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nomEmp' => '0',
                'cnibEmp' => '0',
                'telEmp' => '0',
                'sexe' => '0',
                'motdepassEmp' => '0',
                'codeEmp' => '0',
                'statutEmp' => '0',
                'idEmp' => '0',
                'salaireEmp' => '0',
                'droitEmp' => '0',
                'dateUser' => '0',
                'username' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //Ajout d'un salaire 
    if ($action == 'ajoutSa') {
        $table_name = verifyData($_POST['table_name']);
        $val_sa = ucfirst(verifyData($_POST['saVal']));
        $idUser = intval(ucfirst(verifyData($_POST['user'])));

        $checkSat = $connect->query("SELECT * FROM $table_name WHERE val_sa='" . $val_sa . "' AND del_sa=0");
        if ($checkSat->rowCount() == 0) {
            $ajoutSate = $connect->prepare("INSERT INTO $table_name(val_sa, date_sa, user_sa) VALUES(?,NOW(),?)");
            if ($ajoutSate->execute([$val_sa, $idUser])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //recuperation des salaires
    if ($action == "getSa") {
        $table_name = verifyData($_POST['table_name']);

        $getSaList = $connect->query("SELECT * FROM $table_name WHERE del_sa=0 ORDER BY id_sa DESC");
        if ($getSaList->rowCount() > 0) {
            $response = $getSaList->fetchAll();
        } else {
            $response = [array(
                'id_sa' => '0',
                'val_sa' => '0',
                'user_sa' => '0',
                'Id_user' => '0',
                'del_sa' => '0',
                'date_sa' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //Modifier un salaire
    if ($action == "updSa") {
        $saId = intval(verifyData($_POST['saId']));
        $table_name = verifyData($_POST['table_name']);
        $saVal = ucfirst(verifyData($_POST['saVal']));
        $checkSat = $connect->query("SELECT * FROM $table_name WHERE val_sa='" . $saVal . "' AND del_sa=0");
        if ($checkSat->rowCount() == 0) {
            $updSat = $connect->query("UPDATE $table_name SET val_sa='" . $saVal . "' WHERE id_sa=$saId");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //suppression d'une categorie
    if ($action == "deleteSa") {
        $idSa = intval(verifyData($_POST['idSa']));
        $table_name = verifyData($_POST['table_name']);
        $delCat = $connect->prepare("UPDATE $table_name SET del_sa=? WHERE id_sa=$idSa");
        if ($delCat->execute([1])) {
            echo '1';
        } else {
            echo '0';
        }
        $connect = null;
        return;
    }

    //Ajout d'une categorie
    if ($action == 'ajoutCat') {
        $table_name = verifyData($_POST['table_name']);
        $nomCat = ucfirst(verifyData($_POST['cateName']));
        $user = intval(verifyData($_POST['user']));

        $checkCat = $connect->query("SELECT * FROM $table_name WHERE Nom_cat='" . $nomCat . "' AND Is_delete_cat=0");
        if ($checkCat->rowCount() == 0) {
            $ajoutCate = $connect->prepare("INSERT INTO $table_name(Nom_cat, Date_Cat, Id_user_cat) VALUES(?,NOW(),?)");
            if ($ajoutCate->execute([$nomCat, $user])) {
                echo 1;
            } else {
                echo -4;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation des categories
    if ($action == "getCat") {
        $table_name = verifyData($_POST['table_name']);

        $getCatList = $connect->query("SELECT * FROM $table_name WHERE Is_delete_cat=0 ORDER BY Id_cat DESC");
        if ($getCatList->rowCount() > 0) {
            $response = $getCatList->fetchAll();
        } else {
            $response = [array(
                'Id_cat' => '0',
                'Nom_cat' => '0',
                'Date_Cat' => '0',
                'Id_user' => '0',
                'Is_delete_cat' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //suppression d'une categorie
    if ($action == "deleteCat") {
        $catid = intval(verifyData($_POST['idCat']));
        $table_name = verifyData($_POST['table_name']);
        $delCat = $connect->prepare("UPDATE $table_name SET Is_delete_cat=? WHERE Id_cat=$catid");
        if ($delCat->execute([1])) {
            echo '1';
        } else {
            echo '0';
        }
        $connect = null;
        return;
    }

    //Modifier une categorie
    if ($action == "updCat") {
        $catid = intval(verifyData($_POST['catId']));
        $table_name = verifyData($_POST['table_name']);
        $cateName = ucfirst(verifyData($_POST['cateName']));
        $checkCat = $connect->query("SELECT * FROM $table_name WHERE Nom_cat='" . $cateName . "' AND Is_delete_cat=0");
        if ($checkCat->rowCount() == 0) {
            $updCat = $connect->query("UPDATE $table_name SET Nom_cat='" . $cateName . "' WHERE Id_cat=$catid");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }


    // Ajout d'un produit
    if ($action == 'ajoutProd') {

        $table_name = verifyData($_POST['table_name']);
        $designation = ucfirst(verifyData($_POST['designation']));
        $description = verifyData($_POST['description']);
        $categorie = verifyData($_POST['categorie']);
        $prix = intval(verifyData($_POST['prix']));
        $promo = intval(verifyData($_POST['promo']));
        $user = intval(verifyData($_POST['user']));
        $checkProd = $connect->query("SELECT * FROM $table_name WHERE Nom_pro = '" . $designation . "' AND Is_delete_prod=0");

        if ($checkProd->rowCount() == 0) {

            $idCat = intval($connect->query("SELECT Id_cat FROM categorie WHERE Nom_cat='" . $categorie . "'")->fetch()['Id_cat']);
            $ajoutProd = $connect->prepare("INSERT INTO $table_name(Nom_pro,Prix_pro,Reduice_pro,Id_user,Id_cat,Date_pro,Describe_pro) VALUES(?,?,?,?,?,NOW(),?)");

            if ($ajoutProd->execute([$designation, $prix, $promo, $user, $idCat, $description])) {
                $prodId = intval($connect->query("SELECT Id_pro FROM produits WHERE Nom_pro='" . $designation . "' ORDER BY Id_pro DESC LIMIT 1")->fetch()['Id_pro']);
                $addStock = $connect->prepare("INSERT INTO stock(Id_pro,Id_user_sto,Qt_pro,Date_Sto) VALUES(?,?,?,NOW())");
                $addStock->execute([$prodId, $user, 0]);
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }

        $connect = null;
        return;
    }

    //Recuperer la liste de produit
    if ($action == "getProd") {
        $table_name = verifyData($_POST['table_name']);
        $getProd = $connect->query("SELECT * FROM produits pro, categorie cat, stock stk WHERE pro.Id_pro = stk.Id_pro AND pro.Id_cat = cat.Id_cat AND pro.Is_delete_prod=0 ORDER BY pro.Id_pro DESC");
        if ($getProd->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getProd->fetch()) {
                $response[$i] = array(
                    'Id_pro' => $data['Id_pro'],
                    'Nom_pro' => $data['Nom_pro'],
                    'Prix_pro' => $data['Prix_pro'],
                    'Reduice_pro' => $data['Reduice_pro'],
                    'Id_user' => $data['Id_user'],
                    'Id_cat' => $data['Nom_cat'],
                    'Describe_pro' => $data['Describe_pro'],
                    'Date_pro' => $data['Date_pro'],
                    'Is_delete_prod' => $data['Is_delete_prod'],
                    'stock' => $data['Qt_pro'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'Id_pro' => '-3',
                'Nom_pro' => '-3',
                'Prix_pro' => '-3',
                'Reduice_pro' => '-3',
                'Id_user' => '-3',
                'Id_cat' => '-3',
                'Describe_pro' => '-3',
                'Date_pro' => '-3',
                'Is_delete_prod' => '-3',
                'stock' => '-3',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }



    //Recuperer la liste de produit2222222222222
    if ($action == "getProdList2") {
        $table_name = verifyData($_POST['table_name']);
        $limiteee = verifyData($_POST['limiteee']);
        $searcheee = verifyData($_POST['searcheee']);
        $getProd = $connect->query("SELECT * FROM produits pro, categorie cat, stock stk WHERE pro.Id_pro = stk.Id_pro AND pro.Id_cat = cat.Id_cat AND pro.Is_delete_prod=0 $searcheee ORDER BY pro.Id_pro DESC $limiteee");
        if ($getProd->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getProd->fetch()) {
                $response[$i] = array(
                    'Id_pro' => $data['Id_pro'],
                    'Nom_pro' => $data['Nom_pro'],
                    'Prix_pro' => $data['Prix_pro'],
                    'Reduice_pro' => $data['Reduice_pro'],
                    'Id_user' => $data['Id_user'],
                    'Id_cat' => $data['Nom_cat'],
                    'Describe_pro' => $data['Describe_pro'],
                    'Date_pro' => $data['Date_pro'],
                    'Is_delete_prod' => $data['Is_delete_prod'],
                    'stock' => $data['Qt_pro'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'Id_pro' => '-3',
                'Nom_pro' => '-3',
                'Prix_pro' => '-3',
                'Reduice_pro' => '-3',
                'Id_user' => '-3',
                'Id_cat' => '-3',
                'Describe_pro' => '-3',
                'Date_pro' => '-3',
                'Is_delete_prod' => '-3',
                'stock' => '-3',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }


    //Recuperer la liste de produits achete chez les fournisseurs
    if ($action == "getFourProdList") {
        $table_name = verifyData($_POST['table_name']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $getProd = $connect->query("SELECT * FROM produits pro, categorie cat, ravitail ra,contenuerav cr,fournisseur f WHERE pro.Id_cat = cat.Id_cat AND pro.Is_delete_prod=0 AND ra.Id_rav = cr.Id_rav AND ra.Id_four = cr.Id_four AND cr.Id_four = f.Id_four AND pro.Id_pro = cr.Id_pro $search ORDER BY ra.Date_rav DESC $limit");
        if ($getProd->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getProd->fetch()) {
                $response[$i] = array(
                    'designation' => $data['Nom_pro'],
                    'prix' => $data['prixUnit'],
                    'prod_date' => $data['Date_rav'],
                    'categorie' => $data['Nom_cat'],
                    'fournisseur' => $data['Nom_four'],
                    'quantite' => $data['qts_prod'],
                    'tel_four' => $data['tel_four'],
                    'type' => $data['type_four'],
                    'id_four' => $data['Id_four'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'designation' => '-3',
                'prix' => '-3',
                'prod_date' => '-3',
                'categorie' => '-3',
                'fournisseur' => '-3',
                'quantite' => '-3',
                'tel_four' => '-3',
                'type' => '-3',
                'id_four' => '-3',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }










    //suppression d'un produit
    if ($action == 'delProd') {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['id_prod']));
        $delProd = $connect->query("UPDATE $table_name SET Is_delete_prod=1 WHERE Id_pro='" . $idProd . "'");
        echo 1;
        $connect = null;
        return;
    }

    //modifier e stock
    if ($action == 'updStock') {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['id_prod']));
        $qts = floatval(verifyData($_POST['qts']));

        $upd = $connect->prepare("UPDATE $table_name SET Qt_pro=? WHERE Id_pro=?");
        if ($upd->execute([$qts, $idProd])) {
            echo 1;
        } else {
            echo 1;
        }
        $connect = null;
        return;
    }



    //modifier un produit
    if ($action == "updProd") {

        $table_name = verifyData($_POST['table_name']);
        $designation = ucfirst(verifyData($_POST['designation']));
        $description = verifyData($_POST['description']);
        $categorie = verifyData($_POST['categorie']);
        $prix = intval(verifyData($_POST['prix']));
        $promo = intval(verifyData($_POST['promo']));
        $idProd = intval(verifyData($_POST['id_prod']));

        $checkProd = $connect->query("SELECT * FROM $table_name WHERE Nom_pro = '" . $designation . "' AND Is_delete_prod=0 AND Id_pro !='" . $idProd . "'");
        if ($checkProd->rowCount() == 0) {
            $idCat = intval($connect->query("SELECT Id_cat FROM categorie WHERE Nom_cat='" . $categorie . "'")->fetch()['Id_cat']);
            $updProd = $connect->prepare("UPDATE $table_name SET Nom_pro=?,Prix_pro=?,Reduice_pro=?,Id_cat=?,Describe_pro=? WHERE Id_pro='" . $idProd . "'");
            $updProd->execute([$designation, $prix, $promo, $idCat, $description]);
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }


    //Ajouter un fournisseur
    if ($action == "addFour") {
        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $type = ucfirst(verifyData($_POST['type']));
        $pays = ucfirst(verifyData($_POST['pays']));
        $ville = ucfirst(verifyData($_POST['ville']));
        $adress = verifyData($_POST['adress']);
        $email = verifyData($_POST['email']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $desc = verifyData($_POST['desc']);
        $user = verifyData($_POST['user']);

        $check = $connect->query("SELECT * FROM $table_name WHERE Nom_four='" . $nom . "' AND four_cnib='" . $cnib . "' AND type_four='" . $type . "' AND Status_four=0");
        if ($check->rowCount() == 0) {
            $addFour = $connect->prepare("INSERT INTO $table_name(Nom_four, Date_four, Id_user_four, type_four, adress_four, ville_four, Pays_four, tel_four, codePost_four, email_four,four_cnib,four_desc) VALUES(?,NOW(),?,?,?,?,?,?,?,?,?,?)");
            $addFour->execute([$nom, $user, $type, $adress, $ville, $pays, $tel, '21', $email, $cnib, $desc]);
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //Recuperation des fournisseur
    if ($action == "getfour") {
        $table_name = verifyData($_POST['table_name']);
        $getFour = $connect->query("SELECT * FROM $table_name four, user us WHERE us.Id_user = four.Id_user_four AND four.Status_four=0 ORDER BY four.Id_four DESC");
        if ($getFour->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getFour->fetch()) {
                $response[$i] = array(
                    'Id_four' => $data['Id_four'],
                    'Nom_four' => $data['Nom_four'],
                    'Date_four' => $data['Date_four'],
                    'userFour' => $data['Nom'],
                    'type_four' => $data['type_four'],
                    'adress_four' => $data['adress_four'],
                    'ville_four' => $data['ville_four'],
                    'Pays_four' => $data['Pays_four'],
                    'tel_four' => $data['tel_four'],
                    'codePost_four' => $data['codePost_four'],
                    'email_four' => $data['email_four'],
                    'four_desc' => $data['four_desc'],
                    'four_cnib' => $data['four_cnib'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'Id_four' => '0',
                'Nom_four' => '0',
                'Date_four' => '0',
                'userFour' => '0',
                'type_four' => '0',
                'adress_four' => '0',
                'ville_four' => '0',
                'Pays_four' => '0',
                'tel_four' => '0',
                'codePost_four' => '0',
                'email_four' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //modifier un fournisseur
    if ($action == "updFour") {

        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $type = ucfirst(verifyData($_POST['type']));
        $pays = ucfirst(verifyData($_POST['pays']));
        $ville = ucfirst(verifyData($_POST['ville']));
        $adress = verifyData($_POST['adress']);
        $email = verifyData($_POST['email']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $desc = verifyData($_POST['desc']);
        $idFour = intval(verifyData($_POST['id_four']));

        $check = $connect->query("SELECT * FROM $table_name WHERE Nom_four='" . $nom . "' AND four_cnib='" . $cnib . "' AND type_four='" . $type . "' AND Status_four=0 AND Id_four !='" . $idFour . "'");

        if ($check->rowCount() == 0) {
            $updProd = $connect->prepare("UPDATE $table_name SET Nom_four=?,type_four=?,adress_four=?,ville_four=?,Pays_four=?,tel_four=?,email_four=?,four_cnib=?,four_desc=? WHERE Id_four ='" . $idFour . "'");
            $updProd->execute([$nom, $type, $adress, $ville, $pays, $tel, $email, $cnib, $desc]);
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //suppression d'un fournisseur
    if ($action == 'deleteFour') {
        $table_name = verifyData($_POST['table_name']);
        $idFour = intval(verifyData($_POST['idFour']));
        $delProd = $connect->query("UPDATE $table_name SET Status_four=1 WHERE Id_four='" . $idFour . "'");
        echo 1;
        $connect = null;
        return;
    }

    //Recuperation des clients
    if ($action == "getClient") {
        $table_name = verifyData($_POST['table_name']);
        $getclient = $connect->query("SELECT * FROM $table_name cl, user us WHERE us.Id_user = cl.Id_user_client AND cl.is_active_client=1 ORDER BY cl.Id_client DESC");
        if ($getclient->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getclient->fetch()) {
                $response[$i] = array(
                    'id_client' => $data['Id_client'],
                    'type_client' => $data['type_client'],
                    'nom_complet_client' => $data['nom_complet_client'],
                    'cnib_client' => $data['cnib_client'],
                    'date_client' => $data['date_client'],
                    'tel_client' => $data['tel_client'],
                    'adress_client' => $data['adress_client'],
                    'user' => $data['Nom'],
                    'ville_client' => $data['ville_client'],
                    'desc_client' => $data['desc_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_client' => '0',
                'type_client' => '0',
                'nom_complet_client' => '0',
                'cnib_client' => '0',
                'date_client' => '0',
                'tel_client' => '0',
                'adress_client' => '0',
                'user' => '0',
                'ville_client' => '0',
                'desc_client' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //Recuperation des clients avec limit
    if ($action == "getClientsLimit") {
        $table_name = verifyData($_POST['table_name']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $getclient = $connect->query("SELECT * FROM $table_name cl, user us WHERE us.Id_user = cl.Id_user_client AND cl.is_active_client=1 $search ORDER BY cl.Id_client DESC $limit");
        if ($getclient->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getclient->fetch()) {
                $response[$i] = array(
                    'id_client' => $data['Id_client'],
                    'type_client' => $data['type_client'],
                    'nom_complet_client' => $data['nom_complet_client'],
                    'cnib_client' => $data['cnib_client'],
                    'date_client' => $data['date_client'],
                    'tel_client' => $data['tel_client'],
                    'adress_client' => $data['adress_client'],
                    'user' => $data['Nom'],
                    'ville_client' => $data['ville_client'],
                    'desc_client' => $data['desc_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_client' => '0',
                'type_client' => '0',
                'nom_complet_client' => '0',
                'cnib_client' => '0',
                'date_client' => '0',
                'tel_client' => '0',
                'adress_client' => '0',
                'user' => '0',
                'ville_client' => '0',
                'desc_client' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //Recuperer un client
    if ($action == "getOneClients") {
        $table_name = verifyData($_POST['table_name']);
        $id = verifyData($_POST['id']);
        $getclient = $connect->query("SELECT * FROM $table_name cl, user us WHERE us.Id_user = cl.Id_user_client AND cl.is_active_client=1 AND cl.Id_client='" . $id . "' ORDER BY cl.Id_client DESC");
        if ($getclient->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getclient->fetch()) {
                $response[$i] = array(
                    'id_client' => $data['Id_client'],
                    'type_client' => $data['type_client'],
                    'nom_complet_client' => $data['nom_complet_client'],
                    'cnib_client' => $data['cnib_client'],
                    'date_client' => $data['date_client'],
                    'tel_client' => $data['tel_client'],
                    'adress_client' => $data['adress_client'],
                    'user' => $data['Nom'],
                    'ville_client' => $data['ville_client'],
                    'desc_client' => $data['desc_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_client' => '0',
                'type_client' => '0',
                'nom_complet_client' => '0',
                'cnib_client' => '0',
                'date_client' => '0',
                'tel_client' => '0',
                'adress_client' => '0',
                'user' => '0',
                'ville_client' => '0',
                'desc_client' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //Ajouter un client
    if ($action == "addClient") {
        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $type = ucfirst(verifyData($_POST['type']));
        $ville = ucfirst(verifyData($_POST['ville']));
        $adress = verifyData($_POST['adress']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $desc = verifyData($_POST['desc']);
        $user = verifyData($_POST['user']);

        $check = $connect->query("SELECT * FROM $table_name WHERE nom_complet_client='" . $nom . "' AND cnib_client='" . $cnib . "' AND type_client='" . $type . "' AND is_active_client=1 AND tel_client='" . $tel . "'");
        if ($check->rowCount() == 0) {
            $addclient = $connect->prepare("INSERT INTO $table_name(type_client, nom_complet_client, cnib_client, date_client, tel_client, adress_client, ville_client, Id_user_client, desc_client) VALUES(?,?,?,NOW(),?,?,?,?,?)");
            $addclient->execute([$type, $nom, $cnib, $tel, $adress, $ville, $user, $desc]);
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //modifier un client
    if ($action == "updClient") {

        $table_name = verifyData($_POST['table_name']);
        $nom = ucfirst(verifyData($_POST['nom']));
        $type = ucfirst(verifyData($_POST['type']));
        $ville = ucfirst(verifyData($_POST['ville']));
        $adress = verifyData($_POST['adress']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $desc = verifyData($_POST['desc']);
        $idClient = intval(verifyData($_POST['idClient']));

        $check = $connect->query("SELECT * FROM $table_name WHERE nom_complet_client='" . $nom . "' AND cnib_client='" . $cnib . "' AND type_client='" . $type . "' AND is_active_client=1 AND Id_client !='" . $idClient . "'");

        if ($check->rowCount() == 0) {
            $updProd = $connect->prepare("UPDATE $table_name SET nom_complet_client=?,type_client=?,cnib_client=?,tel_client=?,adress_client=?,ville_client=?,desc_client=?WHERE Id_client ='" . $idClient . "'");
            $updProd->execute([$nom, $type, $cnib, $tel, $adress, $ville, $desc]);
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //suppression d'un client
    if ($action == 'deleteClient') {
        $table_name = verifyData($_POST['table_name']);
        $idClient = intval(verifyData($_POST['idClient']));
        $delClient = $connect->query("UPDATE $table_name SET is_active_client=0 WHERE Id_client='" . $idClient . "'");
        echo 1;
        $connect = null;
        return;
    }


    // recuperation de la liste des ventes 
    if ($action == "getVente") {
        $table_name = verifyData($_POST['table_name']);
        $_isDeliver = verifyData($_POST['_isDeliver']);
        if ($_isDeliver == '1') {
            $getCom = $connect->query("SELECT us.Nom as userName, cl.nom_complet_client as clientName, SUM(cnt.qts_prod) as quantite, SUM(cnt.qts_prod*cnt.prixUnit) as prix, rav.Id_com as idCom, rav.Id_client_com as idClient, rav.Date_com as comDate, rav.is_active_com as etat,rav.is_deliver_com as deliver,rav.is_print_com as is_print FROM $table_name rav, contenuecom cnt, client cl, user us WHERE rav.Id_com = cnt.Id_com AND rav.Id_client_com = cl.Id_client AND rav.Id_user = us.Id_user AND rav.is_deliver_com =1  GROUP BY rav.Id_com ORDER BY rav.Id_com DESC");
        } else {
            $getCom = $connect->query("SELECT us.Nom as userName, cl.nom_complet_client as clientName, SUM(cnt.qts_prod) as quantite, SUM(cnt.qts_prod*cnt.prixUnit) as prix, rav.Id_com as idCom, rav.Id_client_com as idClient, rav.Date_com as comDate, rav.is_active_com as etat,rav.is_deliver_com as deliver,rav.is_print_com as is_print FROM $table_name rav, contenuecom cnt, client cl, user us WHERE rav.Id_com = cnt.Id_com AND rav.Id_client_com = cl.Id_client AND rav.Id_user = us.Id_user AND rav.is_deliver_com =0 GROUP BY rav.Id_com ORDER BY rav.Id_com DESC ");
        }

        if ($getCom->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getCom->fetch()) {
                $response[$i] = array(
                    'idCom' => $data['idCom'],
                    'idClient' => $data['idClient'],
                    'clientName' => $data['clientName'],
                    'nbrProd' => $data['quantite'],
                    'prixTotal' => $data['prix'],
                    'comDate' => $data['comDate'],
                    'comEtat' => $data['etat'],
                    'user' => $data['userName'],
                    'is_deliver_com' => $data['deliver'],
                    'is_print_com' => $data['is_print'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'idCom' => '0',
                'idClient' => '0',
                'clientName' => '0',
                'nbrProd' => '0',
                'prixTotal' => '0',
                'comDate' => '0',
                'comEtat' => '0',
                'user' => '0',
                'is_deliver_com' => '0',
                'is_print_com' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // recuperation de la liste des ventes avec limit 
    if ($action == "getVenteLimit") {
        $table_name = verifyData($_POST['table_name']);
        $_isDeliver = verifyData($_POST['_isDeliver']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);

        $getCom = $connect->query("SELECT us.Nom as userName, cl.nom_complet_client as clientName, SUM(cnt.qts_prod) as quantite, SUM(cnt.qts_prod*cnt.prixUnit) as prix, rav.Id_com as idCom, rav.Id_client_com as idClient, rav.Date_com as comDate, rav.is_active_com as etat,rav.is_deliver_com as deliver,rav.is_print_com as is_print FROM $table_name rav, contenuecom cnt, client cl, user us WHERE rav.Id_com = cnt.Id_com AND rav.Id_client_com = cl.Id_client AND rav.Id_user = us.Id_user AND rav.is_deliver_com ='" . $_isDeliver . "' $search  GROUP BY rav.Id_com ORDER BY rav.Id_com DESC $limit");
        if ($getCom->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getCom->fetch()) {
                $response[$i] = array(
                    'idCom' => $data['idCom'],
                    'idClient' => $data['idClient'],
                    'clientName' => $data['clientName'],
                    'nbrProd' => $data['quantite'],
                    'prixTotal' => $data['prix'],
                    'comDate' => $data['comDate'],
                    'comEtat' => $data['etat'],
                    'user' => $data['userName'],
                    'is_deliver_com' => $data['deliver'],
                    'is_print_com' => $data['is_print'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'idCom' => '0',
                'idClient' => '0',
                'clientName' => '0',
                'nbrProd' => '0',
                'prixTotal' => '0',
                'comDate' => '0',
                'comEtat' => '0',
                'user' => '0',
                'is_deliver_com' => '0',
                'is_print_com' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //Creation d'une Vente 
    if ($action == "creatVente") {
        $table_name = verifyData($_POST['table_name']);
        $idClient = intval(verifyData($_POST['idClient']));
        $user = intval(verifyData($_POST['user']));
        $creatVente = $connect->prepare("INSERT INTO $table_name(Date_com,total_com,Id_user, Id_client_com) VALUES(NOW(),?,?,?)");
        if ($creatVente->execute([0, $user, $idClient])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //Valider la livraison
    if ($action == 'venteIsdeliver') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $valideDeli = $connect->query("UPDATE $table_name SET is_deliver_com=1 WHERE Id_com='" . $idCom . "'");
        echo 1;
        $connect = null;
        return;
    }
    //recuperer les infos de la vente
    if ($action == "getVenteInfos") {
        $table_name = verifyData($_POST['table_name']);
        $idClient = intval(verifyData($_POST['idClient']));

        $getComInfos = $connect->query("SELECT * FROM $table_name com, client cl WHERE com.Id_client_com='" . $idClient . "' AND cl.Id_client = com.Id_client_com ORDER BY com.Id_com DESC LIMIT 1");
        if ($getComInfos->rowCount() > 0) {
            $backInfos = $getComInfos->fetch();
            $response = [array(
                'dateVente' => $backInfos['Date_com'],
                'clientName' => $backInfos['nom_complet_client'],
                'venteId' => $backInfos['Id_com'],
            )];
        } else {
            $response = [array(
                'dateVente' => '0',
                'clientName' => '0',
                'venteId' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //remplire le contenu de la vente 
    if ($action == "fill_vente") {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['idProd']));
        $idClient = intval(verifyData($_POST['idClient']));
        $qts = floatval(verifyData($_POST['qts']));
        $prix = intval(verifyData($_POST['prix']));
        $idCom = intval(verifyData($_POST['idCom']));

        $fillCom = $connect->prepare("INSERT INTO $table_name(Id_pro, Id_client, qts_prod, prixUnit, Id_com) VALUES(?,?,?,?,?)");
        if ($fillCom->execute([$idProd, $idClient, $qts, $prix, $idCom])) {
            $connect->query("UPDATE stock SET Qt_pro=(Qt_pro-'" . $qts . "' ) WHERE Id_pro='" . $idProd . "'");
            $connect->query("UPDATE commande SET total_com=(total_com+($prix*$qts)) WHERE Id_com='" . $idCom . "'");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //recuperation du contenu de la vente 
    if ($action == "getVenteContent") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $comCnt = $connect->query("SELECT rav.Id_com as idCom, cnt.Id_pro as idProd, rav.Id_client_com as idClient, cnt.qts_prod as quantite, cnt.prixUnit as unitPrix, pr.Nom_pro as designation FROM $table_name rav, produits pr, contenuecom cnt, client cl WHERE rav.Id_com = cnt.Id_com AND cnt.Id_pro = pr.Id_pro AND rav.Id_client_com = cl.Id_client AND rav.Id_com ='" . $idCom . "'");
        if ($comCnt->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $comCnt->fetch()) {
                $response[$i] = array(
                    'Id_rav' => $data['idCom'],
                    'idFour' => $data['idClient'],
                    'idProd' => $data['idProd'],
                    'qtsProd' => $data['quantite'],
                    'prixUnit' => $data['unitPrix'],
                    'designation' => $data['designation'],
                    'qtsTotal' => '0',
                    'promo' => '0',
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'Id_rav' => '0',
                'idFour' => '0',
                'idProd' => '0',
                'qtsProd' => '0',
                'prixUnit' => '0',
                'designation' => '0',
                'qtsTotal' => '0',
                'promo' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    // Selection des vente du jour
    if ($action == 'dayVente') {
        $select = $connect->query("SELECT SUM(total_Pay_Com) as total, SUM(amount_Pay_Com) as revenue, sum(total_Pay_Com-amount_Pay_Com) as credit FROM paycom");
        if ($an = $select->fetch()) {
            echo $an['total'] . '-' . $an['revenue'] . '-' . $an['credit'];
        } else {
            echo '0-0-0';
        }

        $connect = null;
        return;
    }

    //supprimer un produit dans une vente
    if ($action == 'deleteVenteItem') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $idProd = intval(verifyData($_POST['idProd']));
        $quantite = intval(verifyData($_POST['quantite']));
        $price = $connect->query("SELECT * FROM contenuecom  WHERE Id_com='" . $idCom . "' AND Id_pro ='" . $idProd . "'")->fetch()['prixUnit'];
        $updcommande = $connect->query("UPDATE commande SET total_com = (total_com-'" . $price . "') WHERE Id_com='" . $idCom . "'");
        $del = $connect->prepare("DELETE FROM $table_name WHERE Id_pro =? AND Id_com=?");
        if ($del->execute([$idProd, $idCom])) {
            $updStock = $connect->prepare("UPDATE stock SET Qt_pro = (Qt_pro+'" . $quantite . "') WHERE Id_pro =?");
            if ($updStock->execute([$idProd])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Supprimer toute la commande
    if ($action == 'deleteVente') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $getVentCont = $connect->query("SELECT * FROM contenuecom WHERE Id_com='" . $idCom . "'");
        while ($vent = $getVentCont->fetch()) {
            $updStock = $connect->query("UPDATE stock SET Qt_pro = (Qt_pro+'" . $vent['qts_prod'] . "') WHERE Id_pro ='" . $vent['Id_pro'] . "'");
            $del = $connect->query("DELETE FROM contenuecom WHERE Id_pro ='" . $vent['Id_pro'] . "' AND Id_com ='" . $idCom . "'");
        }
        $dele = $connect->prepare("DELETE FROM $table_name WHERE Id_com =?");
        if ($dele->execute([$idCom])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation de  infos de paiements du client
    if ($action == 'getVentePay') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $getComPay = $connect->query("SELECT * FROM $table_name pa, commande p WHERE pa.Id_com='" . $idCom . "' AND p.Id_com = pa.Id_com");
        if ($getComPay->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getComPay->fetch()) {
                $response[$i] = array(
                    'typePay' => $data['type_Pay_Com'] . "=>" . $data['id_Pay_Com'],
                    'totalPay' => $data['total_com'],
                    'amountPay' => $data['amount_Pay_Com'],
                    'datePay' => $data['last_update_Pay_Com'],
                    'user' => '0',
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'typePay' => '0',
                'totalPay' => '0',
                'amountPay' => '0',
                'user' => '0',
                'datePay' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    // realiser un paiement d'une commande pour client
    if ($action == "clientNewPaiement") {
        $table_name = verifyData($_POST['table_name']);
        $type = verifyData($_POST['type']);
        $mode = verifyData($_POST['mode']);
        $prix = verifyData($_POST['prix']);
        $paye = verifyData($_POST['paye']);
        $idCom = intval(verifyData($_POST['idCom']));
        $user = intval(verifyData($_POST['user']));

        if ($type == "Chèque") {
            $putPay = $connect->prepare("INSERT INTO $table_name(type_Pay_Com, amount_Pay_Com, Id_com, last_update_Pay_Com,user_com,is_active_pay) VALUES(?,?,?,NOW(),?,0)");
        } else {
            $putPay = $connect->prepare("INSERT INTO $table_name(type_Pay_Com, amount_Pay_Com, Id_com, last_update_Pay_Com,user_com,is_active_pay) VALUES(?,?,?,NOW(),?,1)");
        }
        if ($putPay->execute([$type, $paye, $idCom, $user])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //Creation d'une commande
    if ($action == "creatCont") {
        $table_name = verifyData($_POST['table_name']);
        $idFour = intval(verifyData($_POST['idFour']));
        $user = intval(verifyData($_POST['user']));
        $creatCom = $connect->prepare("INSERT INTO $table_name(Id_four, Id_user, Date_rav) VALUES(?,?,NOW())");
        if ($creatCom->execute([$idFour, $user])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperer les infos de la commande
    if ($action == "getComInfos") {
        $table_name = verifyData($_POST['table_name']);
        $idFour = intval(verifyData($_POST['idFour']));

        $getComInfos = $connect->query("SELECT * FROM $table_name rav, fournisseur fo WHERE rav.Id_four='" . $idFour . "' AND fo.Id_four = rav.Id_four ORDER BY Id_rav DESC LIMIT 1");
        if ($getComInfos->rowCount() > 0) {
            $backInfos = $getComInfos->fetch();
            $response = [array(
                'comId' => $backInfos['Id_rav'],
                'fourName' => $backInfos['Nom_four'],
                'dateCom' => $backInfos['Date_rav'],
            )];
        } else {
            $response = [array(
                'comId' => '0',
                'fourName' => '0',
                'dateCom' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //Recuperer la liste des commandes
    if ($action == "getCom") {
        $table_name = verifyData($_POST['table_name']);
        $getCom = $connect->query("SELECT us.Nom as userName, four.Nom_four as fourName, SUM(cnt.qts_prod) as quantite, SUM(cnt.qts_prod*cnt.prixUnit) as prix, rav.Id_rav as idCom, rav.Id_four as idFour, rav.Date_rav as comDate, rav.status_rave as etat FROM ravitail rav, contenuerav cnt, fournisseur four, user us WHERE rav.Id_rav = cnt.Id_rav AND rav.Id_four = four.Id_four AND rav.Id_user = us.Id_user GROUP BY rav.Id_rav ORDER BY rav.Id_rav DESC");
        if ($getCom->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getCom->fetch()) {
                $response[$i] = array(
                    'idCom' => $data['idCom'],
                    'fourId' => $data['idFour'],
                    'fourNom' => $data['fourName'],
                    'nbrProd' => $data['quantite'],
                    'prixTotal' => $data['prix'],
                    'comDate' => $data['comDate'],
                    'comEtat' => $data['etat'],
                    'user' => $data['userName'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'idCom' => '0',
                'fourId' => '0',
                'fourNom' => '0',
                'nbrProd' => '0',
                'prixTotal' => '0',
                'comDate' => '0',
                'comEtat' => '0',
                'user' => '0',
            )];
        }
        echo json_encode($response);

        $connect = null;
        return;
    }

    //Recuperer la liste des commandes avec limit
    if ($action == "getComLimit") {
        $table_name = verifyData($_POST['table_name']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $isDeliver = verifyData($_POST['isDeliver']);
        $getCom = $connect->query("SELECT us.Nom as userName, four.Nom_four as fourName, SUM(cnt.qts_prod) as quantite, SUM(cnt.qts_prod*cnt.prixUnit) as prix, rav.Id_rav as idCom, rav.Id_four as idFour, rav.Date_rav as comDate, rav.status_rave as etat FROM ravitail rav, contenuerav cnt, fournisseur four, user us WHERE rav.Id_rav = cnt.Id_rav AND rav.Id_four = four.Id_four AND rav.Id_user = us.Id_user AND  rav.status_rave='" . $isDeliver . "' $search GROUP BY rav.Id_rav ORDER BY rav.Id_rav DESC $limit");
        if ($getCom->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getCom->fetch()) {
                $response[$i] = array(
                    'idCom' => $data['idCom'],
                    'fourId' => $data['idFour'],
                    'fourNom' => $data['fourName'],
                    'nbrProd' => $data['quantite'],
                    'prixTotal' => $data['prix'],
                    'comDate' => $data['comDate'],
                    'comEtat' => $data['etat'],
                    'user' => $data['userName'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'idCom' => '0',
                'fourId' => '0',
                'fourNom' => '0',
                'nbrProd' => '0',
                'prixTotal' => '0',
                'comDate' => '0',
                'comEtat' => '0',
                'user' => '0',
            )];
        }
        echo json_encode($response);

        $connect = null;
        return;
    }

    //remplire le contenu de la commande
    if ($action == "fill_com") {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['idProd']));
        $idFour = intval(verifyData($_POST['idFour']));
        $qts = intval(verifyData($_POST['qts']));
        $prix = intval(verifyData($_POST['prix']));
        $idCom = intval(verifyData($_POST['idCom']));

        $fillCom = $connect->prepare("INSERT INTO $table_name(Id_pro, Id_four, qts_prod, prixUnit, Id_rav) VALUES(?,?,?,?,?)");
        if ($fillCom->execute([$idProd, $idFour, $qts, $prix, $idCom])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation de la contenu de la commande
    if ($action == "getCommandeContent") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $comCnt = $connect->query("SELECT rav.Id_rav as idCom, cnt.Id_pro as idProd, rav.Id_four as idFour, cnt.qts_prod as quantite, cnt.prixUnit as unitPrix, pr.Nom_pro as designation FROM ravitail rav, produits pr, contenuerav cnt, payravitail pay, fournisseur fr WHERE rav.Id_rav = cnt.Id_rav AND rav.Id_rav = pay.Id_rav AND cnt.Id_pro = pr.Id_pro AND rav.Id_four = fr.Id_four AND rav.Id_rav ='" . $idCom . "'");
        if ($comCnt->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $comCnt->fetch()) {
                $response[$i] = array(
                    'Id_rav' => $data['idCom'],
                    'idFour' => $data['idFour'],
                    'idProd' => $data['idProd'],
                    'qtsProd' => $data['quantite'],
                    'prixUnit' => $data['unitPrix'],
                    'designation' => $data['designation'],
                    'qtsTotal' => '0',
                    'promo' => '0',
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'Id_rav' => '0',
                'idFour' => '0',
                'idProd' => '0',
                'qtsProd' => '0',
                'prixUnit' => '0',
                'designation' => '0',
                'qtsTotal' => '0',
                'promo' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //supprimer un produit dans une commande
    if ($action == 'deleteComItem') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $idProd = intval(verifyData($_POST['idProd']));
        $quantite = intval(verifyData($_POST['quantite']));
        $del = $connect->prepare("DELETE FROM $table_name WHERE Id_pro =? AND Id_rav=?");
        if ($del->execute([$idProd, $idCom])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //paiement de nouveau commande
    if ($action == "payment") {
        $table_name = verifyData($_POST['table_name']);
        $type = verifyData($_POST['type']);
        $prix = verifyData($_POST['prix']);
        $paye = verifyData($_POST['paye']);
        $idCom = intval(verifyData($_POST['idCom']));

        $putPay = $connect->prepare("INSERT INTO $table_name(type_Pay, total_Pay, amount_Pay, Id_rav, last_update_Pay) VALUES(?,?,?,?,NOW())");
        if ($putPay->execute([$type, $prix, $paye, $idCom])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // realiser un paiement d'une commande
    if ($action == "newPayment") {
        $table_name = verifyData($_POST['table_name']);
        $prix = verifyData($_POST['paye']);
        $idCom = intval(verifyData($_POST['idCom']));

        $updPay = $connect->prepare("UPDATE $table_name SET amount_Pay =(amount_Pay+'" . $prix . "') WHERE Id_rav=?");
        if ($updPay->execute([$idCom])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation de  infos de paiement de commande
    if ($action == 'getCommandePay') {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $getComPay = $connect->query("SELECT * FROM $table_name WHERE Id_rav='" . $idCom . "'");
        if ($getComPay->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getComPay->fetch()) {
                $response[$i] = array(
                    'typePay' => $data['type_Pay'],
                    'totalPay' => $data['total_Pay'],
                    'amountPay' => $data['amount_Pay'],
                    'datePay' => $data['last_update_Pay'],
                    'user' => '0',
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'typePay' => '0',
                'totalPay' => '0',
                'amountPay' => '0',
                'datePay' => '0',
                'user' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    // validation d'une commmande
    if ($action == "validateCom") {
        $table_name = verifyData($_POST['table_name']);
        $idRav = intval(verifyData($_POST['idRav']));
        $upda = $connect->prepare("UPDATE $table_name SET status_rave=1 WHERE Id_rav=?");
        if ($upda->execute([$idRav])) {
            $getComList = $connect->query("Select * FROM contenuerav WHERE Id_rav ='" . $idRav . "'");
            while ($an = $getComList->fetch()) {
                $qts = intval($an['qts_prod']);
                $idProd = intval($an['Id_pro']);
                $upd = $connect->query("UPDATE stock SET Qt_pro = (Qt_pro+'" . $qts . "') WHERE Id_pro ='" . $idProd . "'");
            }
            echo 1;
        } else {
            echo 0;
        }
    }

    //suppression d'une commande contenuerav
    if ($action == 'delCom') {
        $table_name = verifyData($_POST['table_name']);
        $idRav = intval(verifyData($_POST['idRav']));
        $delComElem = $connect->prepare("DELETE FROM contenuerav WHERE Id_rav=?");
        if ($delComElem->execute([$idRav])) {
            $delCom = $connect->prepare("DELETE FROM payravitail WHERE Id_rav=?");
            if ($delCom->execute([$idRav])) {
                $delPay = $connect->query("DELETE FROM $table_name WHERE Id_rav='" . $idRav . "'");
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }

        $connect = null;
        return;
    }
    // mise a jour des infos de l'entreprise
    if ($action == "updCompInfos") {
        $table_name = verifyData($_POST['table_name']);
        $nomComp = verifyData($_POST['nomComp']);
        $adressComp = verifyData($_POST['adressComp']);
        $emailComp = verifyData($_POST['emailComp']);
        $tel1Comp = verifyData($_POST['tel1Comp']);
        $tel2Comp = verifyData($_POST['tel2Comp']);
        $tel3Comp = verifyData($_POST['tel3Comp']);
        $idComp = intval(verifyData($_POST['idComp']));

        $updPay = $connect->prepare("UPDATE $table_name SET Nom_com=?, Tel_com=?,Email_com=?, adress=?, Tel2_com=?, Tel3_com=? WHERE Id=?");
        if ($updPay->execute([$nomComp, $tel1Comp, $emailComp, $adressComp, $tel2Comp, $tel3Comp, $idComp])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation des infos de l'entreprise
    if ($action == 'getComapayDetails') {
        $table_name = verifyData($_POST['table_name']);
        $getCompany = $connect->query("SELECT * FROM $table_name");
        if ($getCompany->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getCompany->fetch()) {
                $response[$i] = array(
                    'id' => $data['Id'],
                    'nom_com' => $data['Nom_com'],
                    'tel_com' => $data['Tel_com'],
                    'logo_com' => $data['Logo_com'],
                    'slogan_com' => $data['Slogan_com'],
                    'email_com' => $data['Email_com'],
                    'adress' => $data['adress'],
                    'tel2_com' => $data['Tel2_com'],
                    'tel3_com' => $data['Tel3_com'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id' => '0',
                'nom_com' => '0',
                'tel_com' => '0',
                'logo_com' => '0',
                'slogan_com' => '0',
                'email_com' => '0',
                'adress' => '0',
                'tel2_com' => '0',
                'tel3_com' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // insertion d'un credit
    if ($action == "sendCredit") {
        $table_name = verifyData($_POST['table_name']);
        $idUser = intval(verifyData($_POST['idUser']));
        $prix = verifyData($_POST['prix']);
        $dateFin = verifyData($_POST['dateFin']);
        $idCom = intval(verifyData($_POST['idCom']));
        $checkCred = $connect->query("SELECT * FROM $table_name WHERE Id_com='" . $idCom . "'");
        if ($checkCred->rowCount() == 0) {
            $setCredit = $connect->prepare("INSERT INTO $table_name(Date_cre,Date_fin_cre,Prix_cre,Id_user,Id_com)VALUES(NOW(),?,?,?,?)");
            if ($setCredit->execute([$dateFin, $prix, $idUser, $idCom])) {
                $updatevente = $connect->prepare("UPDATE commande SET is_print_com=? WHERE Id_com=?");
                if ($updatevente->execute([1, $idCom])) {
                    echo 1;
                } else {
                    echo 0;
                }
            } else {
                echo 0;
            }
        } else {
            $setImp = $connect->prepare("INSERT INTO impression(id_fact, date_imp, im_user) VALUES(?,NOW(),?)");
            if ($setImp->execute([$idCom, $idUser])) {
                echo 1;
            } else {
                echo 0;
            }
        }
        $connect = null;
        return;
    }

    //ajout d'un credit
    if ($action == 'addCredit') {
        $table_name = verifyData($_POST['table_name']);
        $id_client = verifyData($_POST['id_client']);
        $num_facture = verifyData($_POST['num_facture']);
        $total_facture = verifyData($_POST['total_facture']);
        $total_credit = verifyData($_POST['total_credit']);
        $total_paye = verifyData($_POST['total_paye']);
        $date_credit = verifyData($_POST['date_credit']);
        $user_id = verifyData($_POST['user_id']);

        $creatVente = $connect->prepare("INSERT INTO commande(Date_com,total_com,Id_user, Id_client_com,is_active_com,is_print_com,is_deliver_com,is_manual,fact_num) VALUES(?,?,?,?,?,?,?,?,?)");
        if ($creatVente->execute([$date_credit, $total_facture, $user_id, $id_client, 1, 1, 1, 1, $num_facture])) {
            $idCom = $connect->query("SELECT Id_com FROM commande WHERE Id_client_com='" . $id_client . "' AND Id_user='" . $user_id . "' AND is_manual=1 ORDER BY Id_com DESC LIMIT 1")->fetch()['Id_com'];
            $setCredit = $connect->prepare("INSERT INTO $table_name(Date_cre,Date_fin_cre,Prix_cre,amount_pay,Id_user,Id_com)VALUES(?,?,?,?,?,?)");
            if ($setCredit->execute([$date_credit, $date_credit, $total_credit, $total_paye, $user_id, $idCom])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }

        $connect = null;
        return;
    }

    // Supprimer un credit 
    if ($action == 'delCredit') {
        $table_name = verifyData($_POST['table_name']);
        $idCred = verifyData($_POST['idCred']);
        $idcom = $connect->query("SELECT Id_com FROM $table_name WHERE Id_cre='" . $idCred . "'")->fetch()['Id_com'];
        $dele = $connect->query("DELETE FROM commande WHERE Id_com ='" . $idcom . "'");
        $dele = $connect->query("DELETE FROM rembousement WHERE Id_cre_rem ='" . $idCred . "'");
        $dele2 = $connect->prepare("DELETE FROM $table_name WHERE Id_cre =?");
        if ($dele2->execute([$idCred])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }


    // Notification d'impression
    if ($action == "notifyPrint") {
        $table_name = verifyData($_POST['table_name']);
        $idUser = intval(verifyData($_POST['idUser']));
        $idCom = intval(verifyData($_POST['idCom']));
        $setImp = $connect->prepare("INSERT INTO $table_name(id_fact, date_imp, im_user) VALUES(?,NOW(),?)");
        if ($setImp->execute([$idCom, $idUser])) {
            $updatevente = $connect->prepare("UPDATE commande SET is_print_com=? WHERE Id_com=?");
            if ($updatevente->execute([1, $idCom])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // recuperation de la liste de paiement par date
    if ($action == 'getPayments') {
        $table_name = verifyData($_POST['table_name']);
        $mois = verifyData($_POST['mois']);
        $annee = verifyData($_POST['annee']);

        if ($mois == '' && $annee == '') {
            $getdata = $connect->query("SELECT py.last_update_Pay_Com as date_pay, py.amount_Pay_Com as somme, py.id_Pay_Com as id_pay, py.Id_com as id_com,py.type_Pay_Com as pay_type, cl.nom_complet_client as client, u.Nom as agent, c.is_manual as is_manual, c.fact_num as fact_num from commande c, paycom py, client cl, user u WHERE py.type_Pay_Com!='Versement' AND c.Id_com = py.Id_com AND c.Id_client_com = cl.Id_client AND py.user_com = u.Id_user AND py.is_active_pay=1 AND DAY(py.last_update_Pay_Com)=DAY(NOW()) AND YEAR(py.last_update_Pay_Com)=YEAR(NOW()) AND MONTH(py.last_update_Pay_Com) = MONTH(NOW()) ORDER BY py.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'somme_pay' => $data['somme'],
                        'idcom_pay' => $data['id_com'],
                        'id_pay' => $data['id_pay'],
                        'pay_type' => $data['pay_type'] == "Credit=>Espèce" ? "Credit=>Espece" : $data['pay_type'],
                        'user_pay' => $data['agent'],
                        'date_pay' => $data['date_pay'],
                        'client_pay' => $data['client'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'somme_pay' => '0',
                    'idcom_pay' => '0',
                    'id_pay' => '0',
                    'pay_type' => '0',
                    'user_pay' => '0',
                    'date_pay' => '0',
                    'client_pay' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                )];
            }
        } else if ($mois == '' && $annee != '') {
            $getdata = $connect->query("SELECT py.last_update_Pay_Com as date_pay, py.amount_Pay_Com as somme, py.id_Pay_Com as id_pay, py.Id_com as id_com,py.type_Pay_Com as pay_type, cl.nom_complet_client as client, u.Nom as agent, c.is_manual as is_manual, c.fact_num as fact_num from commande c, paycom py, client cl, user u WHERE py.type_Pay_Com!='Versement' AND c.Id_com = py.Id_com AND c.Id_client_com = cl.Id_client AND py.is_active_pay=1 AND py.user_com = u.Id_user AND YEAR(py.last_update_Pay_Com)='" . $annee . "'  ORDER BY py.Id_com DESC ");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'somme_pay' => $data['somme'],
                        'idcom_pay' => $data['id_com'],
                        'id_pay' => $data['id_pay'],
                        'pay_type' => $data['pay_type'] == "Credit=>Espèce" ? "Credit=>Espece" : $data['pay_type'],
                        'user_pay' => $data['agent'],
                        'date_pay' => $data['date_pay'],
                        'client_pay' => $data['client'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'somme_pay' => '0',
                    'idcom_pay' => '0',
                    'id_pay' => '0',
                    'pay_type' => '0',
                    'user_pay' => '0',
                    'date_pay' => '0',
                    'client_pay' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                )];
            }
        } else if ($mois != '' && $annee != 'true') {
            $date = $annee . '-' . $mois . '-' . '1';
            $getdata = $connect->query("SELECT py.last_update_Pay_Com as date_pay, py.amount_Pay_Com as somme, py.id_Pay_Com as id_pay, py.Id_com as id_com,py.type_Pay_Com as pay_type, cl.nom_complet_client as client, u.Nom as agent, c.is_manual as is_manual, c.fact_num as fact_num from commande c, paycom py, client cl, user u WHERE py.type_Pay_Com!='Versement' AND c.Id_com = py.Id_com AND py.is_active_pay=1  AND  c.Id_client_com = cl.Id_client AND py.user_com = u.Id_user AND YEAR(py.last_update_Pay_Com)='" . $annee . "' AND MONTH(py.last_update_Pay_Com)='" . $mois . "'  ORDER BY py.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'somme_pay' => $data['somme'],
                        'idcom_pay' => $data['id_com'],
                        'id_pay' => $data['id_pay'],
                        'pay_type' => $data['pay_type'] == "Credit=>Espèce" ? "Credit=>Espece" : $data['pay_type'],
                        'user_pay' => $data['agent'],
                        'date_pay' => $data['date_pay'],
                        'client_pay' => $data['client'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'somme_pay' => '0',
                    'idcom_pay' => '0',
                    'id_pay' => '0',
                    'pay_type' => '0',
                    'user_pay' => '0',
                    'date_pay' => '0',
                    'client_pay' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                )];
            }
        } else if ($mois != '' && $annee == 'true') {
            $date = $annee . '-' . $mois . '-' . '1';
            $getdata = $connect->query("SELECT py.last_update_Pay_Com as date_pay, py.amount_Pay_Com as somme, py.id_Pay_Com as id_pay, py.Id_com as id_com,py.type_Pay_Com as pay_type, cl.nom_complet_client as client, u.Nom as agent, c.is_manual as is_manual, c.fact_num as fact_num from commande c, paycom py, client cl, user u WHERE py.type_Pay_Com!='Versement' AND c.Id_com = py.Id_com AND py.is_active_pay=1  AND  c.Id_client_com = cl.Id_client AND py.user_com = u.Id_user AND YEAR(py.last_update_Pay_Com)=YEAR('" . $mois . "') AND MONTH(py.last_update_Pay_Com)=MONTH('" . $mois . "') AND DAY(py.last_update_Pay_Com) = DAY('" . $mois . "') ORDER BY py.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'somme_pay' => $data['somme'],
                        'idcom_pay' => $data['id_com'],
                        'id_pay' => $data['id_pay'],
                        'pay_type' => $data['pay_type'] == "Credit=>Espèce" ? "Credit=>Espece" : $data['pay_type'],
                        'user_pay' => $data['agent'],
                        'date_pay' => $data['date_pay'],
                        'client_pay' => $data['client'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'somme_pay' => '0',
                    'idcom_pay' => '0',
                    'id_pay' => '0',
                    'pay_type' => '0',
                    'user_pay' => '0',
                    'date_pay' => '0',
                    'client_pay' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                )];
            }
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // recuperation de la liste de depense par date
    if ($action == 'getDepensePerDate') {
        $table_name = verifyData($_POST['table_name']);
        $mois = verifyData($_POST['mois']);
        $annee = verifyData($_POST['annee']);
        if ($mois == '' && $annee == '') {
            $getdata = $connect->query("SELECT d.Id_dep as id_dep, d.Date_dep as date_dep, d.Prix_dep as prix_dep, d.Raison_dep as raison_dep, u.Nom as agent, d.is_active_dep as etat from  $table_name d,user u WHERE d.is_active_dep=1 AND d.Id_user_dep = u.Id_user AND DAY(d.Date_dep)=DAY(NOW()) AND YEAR(d.Date_dep)=YEAR(NOW()) AND MONTH(d.Date_dep) = MONTH(NOW())");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_dep' => $data['id_dep'],
                        'date_dep' => $data['date_dep'],
                        'prix_dep' => $data['prix_dep'],
                        'raison_dep' => $data['raison_dep'],
                        'id_user' => $data['agent'],
                        'etat' => $data['etat'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_dep' => '0',
                    'date_dep' => '0',
                    'prix_dep' => '0',
                    'raison_dep' => '0',
                    'id_user' => '0',
                    'etat' => '0',
                )];
            }
        } else if ($mois == '' && $annee != '') {
            $getdata = $connect->query("SELECT d.Id_dep as id_dep, d.Date_dep as date_dep, d.Prix_dep as prix_dep, d.Raison_dep as raison_dep, u.Nom as agent, d.is_active_dep as etat from  $table_name d,user u WHERE d.is_active_dep=1 AND d.Id_user_dep = u.Id_user  AND YEAR(d.Date_dep)='" . $annee . "' ");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_dep' => $data['id_dep'],
                        'date_dep' => $data['date_dep'],
                        'prix_dep' => $data['prix_dep'],
                        'raison_dep' => $data['raison_dep'],
                        'id_user' => $data['agent'],
                        'etat' => $data['etat'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_dep' => '0',
                    'date_dep' => '0',
                    'prix_dep' => '0',
                    'raison_dep' => '0',
                    'id_user' => '0',
                    'etat' => '0',
                )];
            }
        } else if ($mois != '' && $annee != 'true') {
            $date = $annee . '-' . $mois . '-' . '1';
            $getdata = $connect->query("SELECT d.Id_dep as id_dep, d.Date_dep as date_dep, d.Prix_dep as prix_dep, d.Raison_dep as raison_dep, u.Nom as agent, d.is_active_dep as etat from  $table_name d,user u  WHERE d.is_active_dep=1 AND d.Id_user_dep = u.Id_user AND YEAR(d.Date_dep)='" . $annee . "' AND MONTH(d.Date_dep)='" . $mois . "'");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_dep' => $data['id_dep'],
                        'date_dep' => $data['date_dep'],
                        'prix_dep' => $data['prix_dep'],
                        'raison_dep' => $data['raison_dep'],
                        'id_user' => $data['agent'],
                        'etat' => $data['etat'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_dep' => '0',
                    'date_dep' => '0',
                    'prix_dep' => '0',
                    'raison_dep' => '0',
                    'id_user' => '0',
                    'etat' => '0',
                )];
            }
        } else if ($mois != '' && $annee == 'true') {
            $date = $annee . '-' . $mois . '-' . '1';
            $getdata = $connect->query("SELECT d.Id_dep as id_dep, d.Date_dep as date_dep, d.Prix_dep as prix_dep, d.Raison_dep as raison_dep, u.Nom as agent, d.is_active_dep as etat from  $table_name d,user u  WHERE d.is_active_dep=1 AND d.Id_user_dep = u.Id_user AND YEAR(d.Date_dep)=YEAR('" . $mois . "') AND MONTH(d.Date_dep)=MONTH('" . $mois . "') AND DAY(d.Date_dep) = DAY('" . $mois . "')");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_dep' => $data['id_dep'],
                        'date_dep' => $data['date_dep'],
                        'prix_dep' => $data['prix_dep'],
                        'raison_dep' => $data['raison_dep'],
                        'id_user' => $data['agent'],
                        'etat' => $data['etat'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_dep' => '0',
                    'date_dep' => '0',
                    'prix_dep' => '0',
                    'raison_dep' => '0',
                    'id_user' => '0',
                    'etat' => '0',
                )];
            }
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    // recuperation de credit
    if ($action == 'getCredit') {
        $table_name = verifyData($_POST['table_name']);
        $mois = verifyData($_POST['mois']);
        $annee = verifyData($_POST['annee']);
        $date = $annee . '-' . $mois . '-' . '1';
        if ($mois == '' && $annee == '') {
            $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as Id_cre, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume, c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client from commande c, credit cr, client cl, user u WHERE c.is_manual=0 AND c.Id_com = cr.Id_com AND c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND DAY(cr.Date_cre)=DAY(NOW()) AND YEAR(cr.Date_cre)=YEAR(NOW()) AND MONTH(cr.Date_cre) = MONTH(NOW()) AND cr.amount_pay<cr.Prix_cre ORDER BY cr.Id_com  DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'nom' => $data['nom'],
                        'nume' => $data['nume'],
                        'paye' => $data['payee'],
                        'reste' => $data['reste'],
                        'dateCred' => $data['debutdate'],
                        'dateRem' => $data['daterem'],
                        'idCred' => $data['Id_cre'],
                        'agent' => $data['agent'],
                        'total_com' => $data['total_com'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                        'client_tel' => $data['tel_client'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'nom' => '0',
                    'nume' => '0',
                    'paye' => '0',
                    'reste' => '0',
                    'dateCred' => '0',
                    'dateRem' => '0',
                    'idCred' => '0',
                    'agent' => '0',
                    'total_com' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                    'client_tel' => '0',
                )];
            }
        } else if ($mois == '' && $annee != '') {
            $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as Id_cre, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume,c.total_com as total_com ,c.is_manual as is_manual, c.fact_num as fact_num,cl.tel_client as tel_client from commande c, credit cr, client cl, user u WHERE c.is_manual=0 AND c.Id_com = cr.Id_com AND c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND YEAR(cr.Date_cre)='" . $annee . "' AND cr.amount_pay<cr.Prix_cre ORDER BY cr.Id_com  DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'nom' => $data['nom'],
                        'nume' => $data['nume'],
                        'paye' => $data['payee'],
                        'reste' => $data['reste'],
                        'dateCred' => $data['debutdate'],
                        'dateRem' => $data['daterem'],
                        'idCred' => $data['Id_cre'],
                        'agent' => $data['agent'],
                        'total_com' => $data['total_com'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                        'client_tel' => $data['tel_client'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'nom' => '0',
                    'nume' => '0',
                    'paye' => '0',
                    'reste' => '0',
                    'dateCred' => '0',
                    'dateRem' => '0',
                    'idCred' => '0',
                    'agent' => '0',
                    'total_com' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                    'client_tel' => '0',
                )];
            }
        } else if ($mois != '' && $annee != 'true') {
            $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as Id_cre, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume,c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client from commande c, credit cr, client cl, user u WHERE c.is_manual=0 AND c.Id_com = cr.Id_com AND c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND YEAR(cr.Date_cre)='" . $annee . "' AND MONTH(cr.Date_cre)=MONTH('" . $date . "') AND cr.amount_pay<cr.Prix_cre ORDER BY cr.Id_com  DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'nom' => $data['nom'],
                        'nume' => $data['nume'],
                        'paye' => $data['payee'],
                        'reste' => $data['reste'],
                        'dateCred' => $data['debutdate'],
                        'dateRem' => $data['daterem'],
                        'idCred' => $data['Id_cre'],
                        'agent' => $data['agent'],
                        'total_com' => $data['total_com'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                        'client_tel' => $data['tel_client'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'nom' => '0',
                    'nume' => '0',
                    'paye' => '0',
                    'reste' => '0',
                    'dateCred' => '0',
                    'dateRem' => '0',
                    'idCred' => '0',
                    'agent' => '0',
                    'total_com' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                    'client_tel' => '0',
                )];
            }
        } else if ($mois != '' && $annee == 'true') {
            $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as Id_cre, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume,c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client  from commande c, credit cr, client cl, user u WHERE c.is_manual=0 AND c.Id_com = cr.Id_com AND c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND YEAR(cr.Date_cre)=YEAR('" . $mois . "') AND MONTH(cr.Date_cre)=MONTH('" . $mois . "') AND DAY(cr.Date_cre) = DAY('" . $mois . "') AND cr.amount_pay<cr.Prix_cre ORDER BY cr.Id_com  DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'nom' => $data['nom'],
                        'nume' => $data['nume'],
                        'paye' => $data['payee'],
                        'reste' => $data['reste'],
                        'dateCred' => $data['debutdate'],
                        'dateRem' => $data['daterem'],
                        'idCred' => $data['Id_cre'],
                        'agent' => $data['agent'],
                        'total_com' => $data['total_com'],
                        'is_manual' => $data['is_manual'],
                        'fact_num' => $data['fact_num'],
                        'client_tel' => $data['tel_client'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'nom' => '0',
                    'nume' => '0',
                    'paye' => '0',
                    'reste' => '0',
                    'dateCred' => '0',
                    'dateRem' => '0',
                    'idCred' => '0',
                    'agent' => '0',
                    'total_com' => '0',
                    'is_manual' => '0',
                    'fact_num' => '0',
                    'client_tel' => '0',
                )];
            }
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    // get prod linechart data
    if ($action == 'getProChartData') {
        // recuperation des nombre de jour du mois
        $monthDays = intval($connect->query("SELECT DAY(LAST_DAY(NOW())) as jours from paycom")->fetch()['jours']);
        $table_name = verifyData($_POST['table_name']);
        $mois = verifyData($_POST['mois']);
        $annee = verifyData($_POST['annee']);
        $date = $annee . '-' . $mois . '-' . '1';
        if ($mois == '' && $annee == '') {
            $getdata = $connect->query("SELECT SUM(total_com) as valeur, HOUR(Date_com) as jours, DAY(LAST_DAY(NOW())) as total from commande WHERE  DAY(Date_com)=DAY(NOW()) AND is_print_com>0 AND YEAR(Date_com)=YEAR(NOW()) AND MONTH(Date_com) = MONTH(NOW()) GROUP BY HOUR(Date_com)");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'number' => '24',
                        'item' => $data['jours'],
                        'val' => $data['valeur'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'number' => strval($monthDays),
                    'item' => '-404',
                    'val' => '-404',
                )];
            }
        }
        if ($mois == !'' && $annee == 'true') {
            $getdata = $connect->query("SELECT SUM(total_com) as valeur, HOUR(Date_com) as jours, DAY(LAST_DAY(NOW())) as total from commande WHERE  is_print_com>0 AND YEAR(Date_com)=YEAR('" . $mois . "') AND MONTH(Date_com)=MONTH('" . $mois . "') AND DAY(Date_com) = DAY('" . $mois . "') GROUP BY HOUR(Date_com)");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'number' => '24',
                        'item' => $data['jours'],
                        'val' => $data['valeur'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'number' => strval($monthDays),
                    'item' => '-404',
                    'val' => '-404',
                )];
            }
        } else if ($mois == '' && $annee != '') {
            $getdata = $connect->query("SELECT sum(total_com) as valeur, MONTH(Date_com) as mois from commande  WHERE is_print_com>0 AND YEAR(Date_com)='" . $annee . "' GROUP BY MONTH(Date_com)");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'number' => '12',
                        'item' => $data['mois'],
                        'val' => $data['valeur'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'number' => strval($monthDays),
                    'item' => '-404',
                    'val' => '-404',
                )];
            }
        } else if ($mois != '' && $annee != '') {
            $getdata = $connect->query("SELECT sum(total_com) as valeur, DAY(Date_com) as jours, DAY(LAST_DAY('" . $date . "')) as total from commande WHERE is_print_com>0 AND YEAR(Date_com)='" . $annee . "' AND MONTH(Date_com)=MONTH('" . $date . "') GROUP BY DAY(Date_com)");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'number' => $data['total'],
                        'item' => $data['jours'],
                        'val' => $data['valeur'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'number' => strval($monthDays),
                    'item' => '-404',
                    'val' => '-404',
                )];
            }
        }

        echo json_encode($response);
        $connect = null;
        return;
    }


    // recuperation de la liste des commandes par date de selection
    if ($action == 'getCommandesListet') {
        $table_name = verifyData($_POST['table_name']);
        $mois = verifyData($_POST['mois']);
        $annee = verifyData($_POST['annee']);
        $date = $annee . '-' . $mois . '-' . '1';
        if ($mois == '' && $annee == '') {
            $getdata = $connect->query("SELECT c.Id_com as idCom, c.Date_com as dateCom, c.total_com as total,u.Nom as agent, cl.nom_complet_client as client, c.is_deliver_com as is_deliver from commande c, client cl, user u WHERE c.is_manual=0 AND c.Id_user = u.Id_user AND c.Id_client_com = cl.Id_client AND DAY(c.Date_com)=DAY(NOW()) AND c.is_print_com>0 AND YEAR(c.Date_com)=YEAR(NOW()) AND MONTH(c.Date_com) = MONTH(NOW()) ORDER BY c.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_com' => $data['idCom'],
                        'date_com' => $data['dateCom'],
                        'total_com' => $data['total'],
                        'user_com' => $data['agent'],
                        'client_com' => $data['client'],
                        'deliver_com' => $data['is_deliver'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_com' => '0',
                    'date_com' => '0',
                    'total_com' => '0',
                    'user_com' => '0',
                    'client_com' => '0',
                    'deliver_com' => '0',
                )];
            }
        } else if ($mois == '' && $annee != '') {
            $getdata = $connect->query("SELECT c.Id_com as idCom, c.Date_com as dateCom, c.total_com as total,u.Nom as agent, cl.nom_complet_client as client, c.is_deliver_com as is_deliver from commande c, client cl, user u WHERE  c.is_manual=0 AND is_print_com>0 AND c.Id_user = u.Id_user AND c.Id_client_com = cl.Id_client  AND YEAR(Date_com)='" . $annee . "' ORDER BY c.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_com' => $data['idCom'],
                        'date_com' => $data['dateCom'],
                        'total_com' => $data['total'],
                        'user_com' => $data['agent'],
                        'client_com' => $data['client'],
                        'deliver_com' => $data['is_deliver'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_com' => '0',
                    'date_com' => '0',
                    'total_com' => '0',
                    'user_com' => '0',
                    'client_com' => '0',
                    'deliver_com' => '0',
                )];
            }
        } else if ($mois != '' && $annee == 'true') {
            $getdata = $connect->query("SELECT c.Id_com as idCom, c.Date_com as dateCom, c.total_com as total,u.Nom as agent, cl.nom_complet_client as client, c.is_deliver_com as is_deliver from commande c, client cl, user u WHERE  c.is_manual=0 AND is_print_com>0 AND c.Id_user = u.Id_user AND c.Id_client_com = cl.Id_client  AND YEAR(Date_com)=YEAR('" . $mois . "') AND MONTH(Date_com)=MONTH('" . $mois . "') AND DAY(Date_com) = DAY('" . $mois . "') ORDER BY c.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_com' => $data['idCom'],
                        'date_com' => $data['dateCom'],
                        'total_com' => $data['total'],
                        'user_com' => $data['agent'],
                        'client_com' => $data['client'],
                        'deliver_com' => $data['is_deliver'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_com' => '0',
                    'date_com' => '0',
                    'total_com' => '0',
                    'user_com' => '0',
                    'client_com' => '0',
                    'deliver_com' => '0',
                )];
            }
        } else if ($mois != '' && $annee != 'true') {
            $getdata = $connect->query("SELECT  c.Id_com as idCom, c.Date_com as dateCom, c.total_com as total,u.Nom as agent, cl.nom_complet_client as client, c.is_deliver_com as is_deliver from commande c, client cl, user u WHERE  c.is_manual=0 AND c.Id_user = u.Id_user AND c.Id_client_com = cl.Id_client AND c.is_print_com>0 AND YEAR(c.Date_com)='" . $annee . "' AND MONTH(c.Date_com)='" . $mois . "' ORDER BY c.Id_com DESC");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'id_com' => $data['idCom'],
                        'date_com' => $data['dateCom'],
                        'total_com' => $data['total'],
                        'user_com' => $data['agent'],
                        'client_com' => $data['client'],
                        'deliver_com' => $data['is_deliver'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'id_com' => '0',
                    'date_com' => '0',
                    'total_com' => '0',
                    'user_com' => '0',
                    'client_com' => '0',
                    'deliver_com' => '0',
                )];
            }
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    //  get commande pay type and num
    if ($action == 'getComPayTypeNum') {
        $table_name = verifyData($_POST['table_name']);
        $getPayNum = $connect->query("SELECT DISTINCT p.Id_com as itemId, p.type_Pay_Com as itemType, n.number_num as itemVal FROM $table_name p, numeropay n WHERE p.Id_com=n.id_com AND p.type_Pay_Com !='Espèce' AND p.type_Pay_Com!='Credit' AND p.type_Pay_Com!='Versement'  ORDER BY p.id_Pay_Com DESC");
        if ($getPayNum->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getPayNum->fetch()) {
                $response[$i] = array(
                    'itemId' => $data['itemId'],
                    'itemVal' => $data['itemVal'],
                    'itemType' => $data['itemType'],
                );
                $i += 1;
            }

            $getPayEspece = $connect->query("SELECT DISTINCT Id_com as itemId, type_Pay_Com as itemType FROM paycom WHERE type_Pay_Com ='Espèce' OR type_Pay_Com ='Versement' GROUP BY Id_com ORDER BY id_Pay_Com DESC");
            if ($getPayEspece->rowCount() > 0) {
                while ($data = $getPayEspece->fetch()) {
                    $response[$i] = array(
                        'itemId' => $data['itemId'],
                        'itemVal' => '========',
                        'itemType' => $data['itemType'],
                    );

                    $i += 1;
                }
            }
        } else {
            $response = [];
            $i = 0;
            $getPayEspece = $connect->query("SELECT DISTINCT Id_com as itemId, type_Pay_Com as itemType FROM paycom WHERE type_Pay_Com ='Espèce' OR type_Pay_Com ='Versement' GROUP BY Id_com ORDER BY id_Pay_Com DESC");
            if ($getPayEspece->rowCount() > 0) {
                while ($data = $getPayEspece->fetch()) {
                    $response[$i] = array(
                        'itemId' => $data['itemId'],
                        'itemVal' => '========',
                        'itemType' => $data['itemType'],
                    );

                    $i += 1;
                }
            } else {
                $response = [array(
                    'itemId' => '0',
                    'itemVal' => '0',
                    'itemType' => '0',
                )];
            }
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // transaction bancaire
    if ($action == "transfert") {
        $table_name = verifyData($_POST['table_name']);
        $nomComp = verifyData($_POST['nomComp']);
        $numComp = verifyData($_POST['numComp']);
        $nomBanq = verifyData($_POST['nomBanq']);
        $agent = verifyData($_POST['agent']);
        $somme = verifyData($_POST['somme']);
        $dateVire = verifyData($_POST['dateVire']);
        $type = verifyData($_POST['type']);
        $idUser = verifyData($_POST['idUser']);
        $desc = verifyData($_POST['desc']);

        $dateVireList = str_split($dateVire);
        // $idCom = $dateVireList[count($dateVireList) - 6] .$dateVireList[count($dateVireList) - 5]. $dateVireList[count($dateVireList) - 4] . $dateVireList[count($dateVireList) - 3] . $dateVireList[count($dateVireList) - 2].$dateVireList[count($dateVireList) - 1].$dateVireList[count($dateVireList) - 1];

        $idCom = intval(substr($dateVire, 3));

        if ($type == 'vire') {
            $setImp = $connect->prepare("INSERT INTO $table_name(Nom_compte_vir, num_Compte_vir, Nom_bank_vir, Agent_vir, Somme_vir, Date_vir,user_vir,desc_vir) VALUES(?,?,?,?,?,?,?,?)");
            if ($setImp->execute([$nomComp, $numComp, $nomBanq, $agent, $somme, $dateVire, $idUser, $desc])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            // verification du retrait
            $check = $connect->query("SELECT * FROM $table_name WHERE id_com_re='" . $idCom . "'");
            if ($check->rowCount() == 1) {
                echo 2;
            } else {
                $upd = $connect->query("UPDATE paycom SET is_active_pay=1,last_update_Pay_Com=NOW() WHERE Id_com='" . $idCom . "' AND type_Pay_Com='Chèque'");
                $setImp = $connect->prepare("INSERT INTO $table_name(Nom_compte_ret, num_Compte_ret, Nom_bank_ret, Agent_ret, Somme_ret, Date_ret,id_com_re,user_re,desc_re,numFact_re) VALUES(?,?,?,?,?,NOW(),?,?,?,?)");
                if ($setImp->execute([$nomComp, $numComp, $nomBanq, $agent, $somme, $idCom, $idUser, $desc, $dateVire])) {

                    echo 1;
                } else {
                    echo 0;
                }
            }
        }

        $connect = null;
        return;
    }
    //recuperation de la list de virement   
    if ($action == 'getVireLis') {
        $table_name = verifyData($_POST['table_name']);
        $getvire = $connect->query("SELECT * FROM $table_name vi, user u WHERE vi.user_vir=u.Id_user ORDER BY vi.Id_vir DESC ");
        if ($getvire->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvire->fetch()) {
                $response[$i] = array(
                    'nom_compte' => $data['Nom_compte_vir'],
                    'num_compte' => $data['num_Compte_vir'],
                    'banq_nom' => $data['Nom_bank_vir'],
                    'agent' => $data['Agent_vir'],
                    'somme' => $data['Somme_vir'],
                    'date_vire' => $data['Date_vir'],
                    'id_vire' => $data['Id_vir'],
                    'process' => $data['Nom'],
                    'desc_vire' => $data['desc_vir'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom_compte' => '0',
                'num_compte' => '0',
                'banq_nom' => '0',
                'agent' => '0',
                'somme' => '0',
                'date_vire' => '0',
                'id_vire' => '0',
                'process' => '0',
                'desc_vire' => '0',

            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // supprimer un virement
    if ($action == 'delVire') {
        $table_name = verifyData($_POST['table_name']);
        $idVire = intval(verifyData($_POST['idVire']));
        $delvirElem = $connect->prepare("DELETE FROM $table_name WHERE Id_vir=?");
        if ($delvirElem->execute([$idVire])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //enregistrement de depense
    if ($action == "seaveDepense") {
        $table_name = verifyData($_POST['table_name']);
        $somme = verifyData($_POST['somme']);
        $desc = verifyData($_POST['desc']);
        $idUser = verifyData($_POST['idUser']);
        $setversement = $connect->prepare("INSERT INTO $table_name(Date_dep, Prix_dep, Raison_dep, Id_user_dep) VALUES(NOW(),?,?,?)");
        if ($setversement->execute([$somme, $desc, $idUser])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Valider une depense
    if ($action == 'validateDep') {
        $table_name = verifyData($_POST['table_name']);
        $idep = intval(verifyData($_POST['idep']));
        $valideDep = $connect->prepare("UPDATE $table_name SET is_active_dep = 1 WHERE Id_dep=?");
        if ($valideDep->execute([$idep])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // supprimer une depense
    if ($action == 'delDep') {
        $table_name = verifyData($_POST['table_name']);
        $idep = intval(verifyData($_POST['idep']));
        $delElem = $connect->prepare("DELETE FROM $table_name WHERE Id_dep=?");
        if ($delElem->execute([$idep])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // recuperation de depense
    if ($action == 'getDepenseLis') {
        $table_name = verifyData($_POST['table_name']);
        $getvire = $connect->query("SELECT * FROM $table_name d, user u WHERE u.Id_user=d.Id_user_dep ORDER BY d.Id_dep DESC");
        if ($getvire->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvire->fetch()) {
                $response[$i] = array(
                    'id_dep' => $data['Id_dep'],
                    'date_dep' => $data['Date_dep'],
                    'prix_dep' => $data['Prix_dep'],
                    'raison_dep' => $data['Raison_dep'],
                    'id_user' => $data['Nom'],
                    'etat' => $data['is_active_dep'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_dep' => '0',
                'date_dep' => '0',
                'prix_dep' => '0',
                'raison_dep' => '0',
                'id_user' => '0',
                'etat' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    // recuperation de depense avec Limit
    if ($action == 'getDepenseLisLimit') {
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $table_name = verifyData($_POST['table_name']);
        $getvire = $connect->query("SELECT * FROM $table_name d, user u WHERE u.Id_user=d.Id_user_dep $search ORDER BY d.Id_dep DESC $limit");
        if ($getvire->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvire->fetch()) {
                $response[$i] = array(
                    'id_dep' => $data['Id_dep'],
                    'date_dep' => $data['Date_dep'],
                    'prix_dep' => $data['Prix_dep'],
                    'raison_dep' => $data['Raison_dep'],
                    'id_user' => $data['Nom'],
                    'etat' => $data['is_active_dep'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_dep' => '0',
                'date_dep' => '0',
                'prix_dep' => '0',
                'raison_dep' => '0',
                'id_user' => '0',
                'etat' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    //recuperation de la list de retrait
    if ($action == 'getRetraitLis') {
        $table_name = verifyData($_POST['table_name']);
        $getvire = $connect->query("SELECT * FROM $table_name re,user u WHERE re.user_re=u.Id_user ORDER BY re.Id_ret DESC");
        if ($getvire->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvire->fetch()) {
                $response[$i] = array(
                    'nom_compte' => $data['Nom_compte_ret'],
                    'num_compte' => $data['num_Compte_ret'],
                    'banq_nom' => $data['Nom_bank_ret'],
                    'agent' => $data['Agent_ret'],
                    'somme' => $data['Somme_ret'],
                    'date_vire' => $data['Date_ret'],
                    'id_ret' => $data['Id_ret'],
                    'desc_re' => $data['desc_re'],
                    'process' => $data['Nom'],
                    'id_com' => $data['id_com_re'],
                    'fact_num' => $data['numFact_re'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom_compte' => '0',
                'num_compte' => '0',
                'banq_nom' => '0',
                'agent' => '0',
                'somme' => '0',
                'date_vire' => '0',
                'id_ret' => '0',
                'desc_re' => '0',
                'process' => '0',
                'id_com' => '0',
                'fact_num' => '0',

            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // supprimer un retrait
    if ($action == 'delRet') {
        $table_name = verifyData($_POST['table_name']);
        $idret = intval(verifyData($_POST['idret']));

        $updPay = $connect->query("UPDATE paycom SET is_active_pay=0 WHERE type_Pay_Com='Chèque' AND Id_com=(SELECT id_com_re FROM $table_name WHERE Id_ret='" . $idret . "')");
        $delvirElem = $connect->prepare("DELETE FROM $table_name WHERE Id_ret=?");
        if ($delvirElem->execute([$idret])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // creation d'un compte de versement
    if ($action == "compteVersement") {
        $table_name = verifyData($_POST['table_name']);
        $user = verifyData($_POST['user']);
        $idClient = verifyData($_POST['idClient']);
        $check = $connect->query("SELECT * FROM $table_name WHERE id_client_cpt='" . $idClient . "' AND is_used_cpt<=1");
        if ($check->rowCount() == 0) {
            $createAccount = $connect->prepare("INSERT INTO $table_name(id_client_cpt, date_cpt, user_cpt) VALUES(?,NOW(),?)");
            if ($createAccount->execute([$idClient, $user])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 97;
        }

        $connect = null;
        return;
    }
    // supprimer un compte de versement
    if ($action == 'delcompteVers') {
        $table_name = verifyData($_POST['table_name']);
        $id_cpt = intval(verifyData($_POST['id_cpt']));

        $del = $connect->prepare("DELETE FROM versenent WHERE id_cpt_vers=?");
        if ($del->execute([$id_cpt])) {
            $delver = $connect->prepare("DELETE FROM $table_name WHERE id_cpt=?");
            if ($delver->execute([$id_cpt])) {
                echo 1;
            } else {
                echo 0;
            }
        }
        $connect = null;
        return;
    }

    // ajouter un versement
    if ($action == "addversement") {
        $table_name = verifyData($_POST['table_name']);
        $deposant = verifyData($_POST['deposant']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $somme = intval(verifyData($_POST['somme']));
        $idUser = verifyData($_POST['idUser']);
        $id_cpt = verifyData($_POST['id_cpt']);
        $setversement = $connect->prepare("INSERT INTO $table_name(Somme_vers, Date_vers, Id_user_vers,Nom_vers,Cnib_vers,tel_vers,id_cpt_vers) VALUES(?,NOW(),?,?,?,?,?)");
        if ($setversement->execute([$somme, $idUser, $deposant, $cnib, $tel, $id_cpt])) {

            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation de la list de versement du jour
    if ($action == 'getDaylistVersementCount') {

        $table_name = verifyData($_POST['table_name']);
        $getvers = $connect->query("SELECT cl.Id_client as id_client, cl.tel_client as tel, v.id_cpt_vers as id_cpt, v.Somme_vers as total, cl.nom_complet_client as client, u.Nom as agent,v.Date_vers as dateCre, v.is_active_vers as etat FROM compteversement c, versenent v, client cl,user u WHERE cl.Id_client = c.id_client_cpt AND v.id_cpt_vers=c.id_cpt AND c.user_cpt = u.Id_user AND DAY(v.Date_vers)=DAY(NOW()) AND YEAR(v.Date_vers)=YEAR(NOW()) AND MONTH(v.Date_vers)=MONTH(NOW()) AND v.is_active_vers=1 ORDER BY c.id_cpt DESC");
        $response = [];
        if ($getvers->rowCount() > 0) {
            $i = 0;
            while ($data = $getvers->fetch()) {
                $response[$i] = array(
                    'id_cpt' => $data['id_cpt'],
                    'id_client' => $data['id_client'],
                    'client_cpt' => $data['client'],
                    'date_cpt' => $data['dateCre'],
                    'etat_cpt' => $data['etat'],
                    'somme_cpt' => $data['total'],
                    'agent_cpt' => $data['agent'],
                    'tel_cpt' => $data['tel'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_cpt' => '0',
                'id_client' => '0',
                'client_cpt' => '0',
                'date_cpt' => '0',
                'etat_cpt' => '0',
                'somme_cpt' => '0',
                'agent_cpt' => '0',
                'tel_cpt' => '-2',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //recuperation de la list de versement
    if ($action == 'getAllVersLis') {
        $table_name = verifyData($_POST['table_name']);
        $getvers = $connect->query("SELECT cl.Id_client as id_client, cl.tel_client as tel, c.id_cpt as id_cpt, c.montant_cpt as total, cl.nom_complet_client as client, u.Nom as agent,c.date_cpt as dateCre, c.is_used_cpt as etat FROM compteversement c, client cl,user u WHERE cl.Id_client = c.id_client_cpt AND c.user_cpt = u.Id_user ORDER BY c.id_cpt DESC");
        if ($getvers->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvers->fetch()) {
                $response[$i] = array(
                    'id_cpt' => $data['id_cpt'],
                    'id_client' => $data['id_client'],
                    'client_cpt' => $data['client'],
                    'date_cpt' => $data['dateCre'],
                    'etat_cpt' => $data['etat'],
                    'somme_cpt' => $data['total'],
                    'agent_cpt' => $data['agent'],
                    'tel_cpt' => $data['tel'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_cpt' => '0',
                'id_client' => '0',
                'client_cpt' => '0',
                'date_cpt' => '0',
                'etat_cpt' => '0',
                'somme_cpt' => '0',
                'agent_cpt' => '0',
                'tel_cpt' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //recuperation de la list de versement avec limit
    if ($action == 'getAllVersLisLimit') {
        $table_name = verifyData($_POST['table_name']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $getvers = $connect->query("SELECT cl.Id_client as id_client, cl.tel_client as tel, c.id_cpt as id_cpt, c.montant_cpt as total, cl.nom_complet_client as client, u.Nom as agent,c.date_cpt as dateCre, c.is_used_cpt as etat FROM compteversement c, client cl,user u WHERE cl.Id_client = c.id_client_cpt AND c.user_cpt = u.Id_user $search ORDER BY c.id_cpt DESC $limit");
        if ($getvers->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvers->fetch()) {
                $verNonValid = $connect->query("SELECT * FROM compteversement cp, versenent ve WHERE cp.id_cpt = ve.id_cpt_vers AND cp.id_cpt = '" . $data['id_cpt'] . "' AND ve.is_active_vers = 0")->rowCount();
                $verAchat = $connect->query("SELECT * FROM compteversement cpt, sortiecompte sc WHERE sc.id_cpt_sc = cpt.id_cpt AND cpt.id_cpt =  '" . $data['id_cpt'] . "'")->rowCount();
                $response[$i] = array(
                    'id_cpt' => $data['id_cpt'],
                    'id_client' => $data['id_client'],
                    'client_cpt' => $data['client'],
                    'date_cpt' => $data['dateCre'],
                    'etat_cpt' => $data['etat'],
                    'somme_cpt' => $data['total'],
                    'agent_cpt' => $data['agent'] . "-" . $verNonValid . "-" . $verAchat,
                    'tel_cpt' => $data['tel'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_cpt' => '0',
                'id_client' => '0',
                'client_cpt' => '0',
                'date_cpt' => '0',
                'etat_cpt' => '0',
                'somme_cpt' => '0',
                'agent_cpt' => '0',
                'tel_cpt' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //recuperation de la list de versement
    if ($action == 'getVersLis') {
        $table_name = verifyData($_POST['table_name']);
        $id_cpt = intval(verifyData($_POST['id_cpt']));
        $getvers = $connect->query("SELECT * FROM $table_name ve, user u WHERE u.Id_user=ve.Id_user_vers AND ve.id_cpt_vers='" . $id_cpt . "'");
        if ($getvers->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getvers->fetch()) {
                $response[$i] = array(
                    'id_vers' => $data['Id_vers'],
                    'somme_vers' => $data['Somme_vers'],
                    'date_vers' => $data['Date_vers'],
                    'user_vers' => $data['Nom'],
                    'nom_vers' => $data['Nom_vers'],
                    'cnib_vers' => $data['Cnib_vers'],
                    'tel_vers' => $data['tel_vers'],
                    'is_active_vers' => $data['is_active_vers'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_vers' => '0',
                'somme_vers' => '0',
                'date_vers' => '0',
                'user_vers' => '0',
                'nom_vers' => '0',
                'cnib_vers' => '0',
                'tel_vers' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // recuperer un seul versement
    if ($action == "getSingleVers") {
        $table_name = verifyData($_POST['table_name']);
        $id_client = verifyData($_POST['id_client']);
        $getver = $connect->query("SELECT * FROM $table_name WHERE id_client_cpt='" . $id_client . "' AND is_used_cpt=1");
        if ($an = $getver->fetch()) {
            echo $an['montant_cpt'];
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //terminer un versement
    if ($action == "terminateVers") {
        $table_name = verifyData($_POST['table_name']);
        $id_cpt = verifyData($_POST['id_cpt']);
        $upd = $connect->prepare("UPDATE compteversement SET is_used_cpt=1 WHERE id_cpt=?");
        if ($upd->execute([$id_cpt])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    //Appliquer un versement
    if ($action == "applyVersement") {
        $table_name = verifyData($_POST['table_name']);
        $id_client = verifyData($_POST['id_client']);
        $upd = $connect->prepare("UPDATE $table_name SET is_used_cpt=2 WHERE id_client_cpt=? AND is_used_cpt=1");
        if ($upd->execute([$id_client])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // valider un versement
    if ($action == "validateVer") {
        $table_name = verifyData($_POST['table_name']);
        $id_ver = verifyData($_POST['id_ver']);
        $del = $connect->prepare("UPDATE $table_name SET is_active_vers =1, Date_vers=NOW() WHERE Id_vers=?");
        if ($del->execute([$id_ver])) {
            $upd = $connect->query("UPDATE compteversement SET montant_cpt=(montant_cpt+(SELECT Somme_vers From versenent WHERE Id_vers='" . $id_ver . "'))  WHERE id_cpt =(SELECT id_cpt_vers From versenent WHERE Id_vers='" . $id_ver . "')");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // supprimer un versement
    if ($action == "delVer") {
        $table_name = verifyData($_POST['table_name']);
        $id_ver = verifyData($_POST['id_ver']);

        $del = $connect->prepare("DELETE FROM $table_name WHERE Id_vers=?");
        if ($del->execute([$id_ver])) {
            echo 1;
        } else {
            echo 0;
        }

        $connect = null;
        return;
    }

    // recuperation de tous les credits
    if ($action == 'getAllCredit') {

        $table_name = verifyData($_POST['table_name']);
        $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as idCred, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume, c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client from commande c, credit cr, client cl, user u WHERE c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND c.Id_com = cr.Id_com ORDER BY cr.Id_cre DESC");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'nom' => $data['nom'],
                    'total_com' => $data['total_com'],
                    'nume' => $data['nume'],
                    'paye' => strval($data['payee']),
                    'reste' => $data['reste'],
                    'dateCred' => $data['debutdate'],
                    'dateRem' => $data['daterem'],
                    'idCred' => $data['idCred'],
                    'agent' => $data['agent'],
                    'is_manual' => $data['is_manual'],
                    'fact_num' => $data['fact_num'],
                    'client_tel' => $data['tel_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom' => '0',
                'nume' => '0',
                'paye' => '0',
                'reste' => '0',
                'dateCred' => '0',
                'dateRem' => '0',
                'idCred' => '0',
                'agent' => '0',
                'is_manual' => '0',
                'fact_num' => '0',
                'client_tel' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    // recuperation de tous les credits avec limit
    if ($action == 'allCreditLimit') {

        $table_name = verifyData($_POST['table_name']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as idCred, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume, c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client from commande c, credit cr, client cl, user u WHERE c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND c.Id_com = cr.Id_com $search ORDER BY cr.Id_cre DESC $limit");
        if ($getdata->rowCount() > 0) {

            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $nbr = $connect->query("SELECT COUNT(re.Id_rem) as nbr FROM rembousement re, credit cr WHERE cr.Id_cre = re.Id_cre_rem AND cr.Id_cre ='" . $data['idCred'] . "' AND re.is_valide = 0")->fetch()['nbr'];
                $response[$i] = array(
                    'nom' => $data['nom'] . '-=/' . $nbr,
                    'total_com' => $data['total_com'],
                    'nume' => $data['nume'],
                    'paye' => strval($data['payee']),
                    'reste' => $data['reste'],
                    'dateCred' => $data['debutdate'],
                    'dateRem' => $data['daterem'],
                    'idCred' => $data['idCred'],
                    'agent' => $data['agent'],
                    'is_manual' => $data['is_manual'],
                    'fact_num' => $data['fact_num'],
                    'client_tel' => $data['tel_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom' => '0',
                'nume' => '0',
                'paye' => '0',
                'reste' => '0',
                'dateCred' => '0',
                'dateRem' => '0',
                'idCred' => '0',
                'agent' => '0',
                'is_manual' => '0',
                'fact_num' => '0',
                'client_tel' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    // rembousement de credit
    if ($action == "RembourseCred") {
        $table_name = verifyData($_POST['table_name']);
        $deposant = verifyData($_POST['deposant']);
        $tel = verifyData($_POST['tel']);
        $cnib = verifyData($_POST['cnib']);
        $somme = verifyData($_POST['somme']);
        $idCred = verifyData($_POST['idCred']);
        $idUser = verifyData($_POST['idUser']);
        $payType = verifyData($_POST['payType']);
        $numero = verifyData($_POST['numero']);
        $checkVal = 'Credit=>' . $payType;
        $idCom = $connect->query("SELECT Id_com FROM credit WHERE Id_cre='" . $idCred . "'")->fetch()['Id_com'];
        $updComPay = $connect->prepare("INSERT INTO paycom(type_Pay_Com, amount_Pay_Com, Id_com, last_update_Pay_Com, user_com) VALUES(?,?,?,NOW(),?)");

        if ($updComPay->execute([$checkVal, $somme, $idCom, $idUser])) {
            $idPayCom = $connect->query("SELECT id_Pay_Com FROM paycom WHERE Id_com='" . $idCom . "' AND amount_Pay_Com='" . $somme . "' AND type_Pay_Com='" . $checkVal . "' ORDER BY id_Pay_Com DESC LIMIT 1 ")->fetch()['id_Pay_Com'];
            $setRemb = $connect->prepare("INSERT INTO $table_name(Date_rem, Nom_rem, Card_id_rem, tel_rem, Id_cre_rem,Id_user_rem,montant_pay_rem,typePay_rem,payNum_rem,id_payCom_rem,is_valide) VALUES(NOW(),?,?,?,?,?,?,?,?,?,?)");
            if ($setRemb->execute([$deposant, $cnib, $tel, $idCred, $idUser, $somme, $payType, $numero, $idPayCom, 0])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }



        $connect = null;
        return;
    }

    // Valider un remboursement
    if ($action == 'valideRembourse') {
        $table_name = verifyData($_POST['table_name']);
        $prix = verifyData($_POST['prix']);
        $idRem = intval(verifyData($_POST['idRem']));

        $getCredId = $connect->query("SELECT Id_cre_rem FROM $table_name WHERE Id_rem ='" . $idRem . "'")->fetch()['Id_cre_rem'];
        $updCred = $connect->prepare("UPDATE credit SET amount_pay=(amount_pay+$prix) WHERE Id_cre =? ");
        if ($updCred->execute([$getCredId])) {
            $upd = $connect->query("UPDATE $table_name SET is_valide=1 WHERE Id_rem ='" . $idRem . "'");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // recuperation de la list des credits
    if ($action == 'getRemboursList') {
        $table_name = verifyData($_POST['table_name']);
        $idCred = intval(verifyData($_POST['idCred']));
        $getdata = $connect->query("SELECT * FROM $table_name re, user u WHERE re.Id_cre_rem = '" . $idCred . "' AND re.Id_user_rem = u.Id_user ORDER BY re.Id_rem DESC");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'id_rem' => $data['Id_rem'],
                    'date_rem' => $data['Date_rem'],
                    'nom_rem' => $data['Nom_rem'],
                    'card_id_rem' => $data['Card_id_rem'],
                    'tel_rem' => $data['tel_rem'],
                    'id_user_rem' => $data['Nom'],
                    'montant_pay_rem' => $data['montant_pay_rem'],
                    'numero' => $data['payNum_rem'],
                    'pay_type' => $data['typePay_rem'],
                    'is_valid' => $data['is_valide'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_rem' => '0',
                'date_rem' => '0',
                'nom_rem' => '0',
                'card_id_rem' => '0',
                'tel_rem' => '0',
                'id_user_rem' => '0',
                'montant_pay_rem' => '0',
                'numero' => '0',
                'pay_type' => '0',
                'is_valid' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // supprimer un remboursement
    if ($action == 'delRembourse') {
        $table_name = verifyData($_POST['table_name']);
        $idRem = intval(verifyData($_POST['idRem']));
        // $upd = $connect->query("UPDATE credit SET amount_pay=(amount_pay-(SELECT montant_pay_rem FROM rembousement WHERE Id_rem='" . $idRem . "')) WHERE Id_cre=( SELECT Id_cre_rem FROM rembousement WHERE Id_rem='" . $idRem . "')");
        $idPayCom = $connect->query("SELECT id_payCom_rem FROM rembousement WHERE Id_rem='" . $idRem . "'")->fetch()['id_payCom_rem'];
        $delPayComCred = $connect->query("DELETE FROM paycom WHERE id_Pay_Com='" . $idPayCom . "'");
        $delrem = $connect->prepare("DELETE FROM $table_name WHERE Id_rem=?");
        if ($delrem->execute([$idRem])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // inventaire de la boutique
    // recuperation de la liste des commandes pour inventaire
    if ($action == 'getInventaireComList') {
        $table_name = verifyData($_POST['table_name']);
        $debut = verifyData($_POST['debut']);
        $fin = verifyData($_POST['fin']);

        $getdata = $connect->query("SELECT c.Id_com as idCom, c.Date_com as dateCom, c.total_com as total,u.Nom as agent, cl.nom_complet_client as client, c.is_deliver_com as is_deliver from commande c, client cl, user u WHERE  c.Id_user = u.Id_user AND c.Id_client_com = cl.Id_client AND c.is_print_com >0 AND c.Date_com>='" . $debut . "' AND c.Date_com<='" . $fin . "' ORDER BY c.Id_com ASC");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'id_com' => $data['idCom'],
                    'date_com' => $data['dateCom'],
                    'total_com' => $data['total'],
                    'user_com' => $data['agent'],
                    'client_com' => $data['client'],
                    'deliver_com' => $data['is_deliver'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_com' => '0',
                'date_com' => '0',
                'total_com' => '0',
                'user_com' => '0',
                'client_com' => '0',
                'deliver_com' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // recuperation des paiement pour inventaire
    if ($action == 'inventairePayList') {
        $table_name = verifyData($_POST['table_name']);
        $debut = verifyData($_POST['debut']);
        $fin = verifyData($_POST['fin']);

        $getdata = $connect->query("SELECT py.last_update_Pay_Com as date_pay, py.amount_Pay_Com as somme, py.id_Pay_Com as id_pay, py.Id_com as id_com,py.type_Pay_Com as pay_type, cl.nom_complet_client as client, u.Nom as agent, c.fact_num as fact_num, c.is_manual as is_manual from commande c, paycom py, client cl, user u WHERE c.Id_com = py.Id_com AND py.is_active_pay=1  AND  c.Id_client_com = cl.Id_client AND py.user_com = u.Id_user AND py.last_update_Pay_Com>='" . $debut . "' AND py.last_update_Pay_Com<='" . $fin . "'");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'somme_pay' => $data['somme'],
                    'idcom_pay' => $data['id_com'],
                    'id_pay' => $data['id_pay'],
                    'pay_type' => $data['pay_type'],
                    'user_pay' => $data['agent'],
                    'date_pay' => $data['date_pay'],
                    'client_pay' => $data['client'],
                    'fact_num' => $data['fact_num'],
                    'is_manual' => $data['is_manual'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'somme_pay' => '0',
                'idcom_pay' => '0',
                'id_pay' => '0',
                'pay_type' => '0',
                'user_pay' => '0',
                'date_pay' => '0',
                'client_pay' => '0',
                'fact_num' => '0',
                'is_manual' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }
    // recuperation de credit pour inventaire
    if ($action == 'inventairecredit') {
        $table_name = verifyData($_POST['table_name']);
        $debut = verifyData($_POST['debut']);
        $fin = verifyData($_POST['fin']);
        $getdata = $connect->query("SELECT u.Nom as agent, cr.Id_cre as Id_cre, cr.Date_cre as debutdate, cr.Date_fin_cre as daterem, cl.nom_complet_client as nom,(cr.Prix_cre-cr.amount_pay) as reste,cr.amount_pay as payee, cr.Id_com as nume, c.total_com as total_com,c.is_manual as is_manual, c.fact_num as fact_num, cl.tel_client as tel_client  from commande c, credit cr, client cl, user u WHERE c.Id_com = cr.Id_com AND c.Id_client_com = cl.Id_client AND u.Id_user = cr.Id_user AND cr.Date_cre>='" . $debut . "' AND cr.Date_cre<='" . $fin . "' AND cr.amount_pay<cr.Prix_cre");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'nom' => $data['nom'],
                    'nume' => $data['nume'],
                    'paye' => $data['payee'],
                    'reste' => $data['reste'],
                    'dateCred' => $data['debutdate'],
                    'dateRem' => $data['daterem'],
                    'idCred' => $data['Id_cre'],
                    'agent' => $data['agent'],
                    'total_com' => $data['total_com'],
                    'is_manual' => $data['is_manual'],
                    'fact_num' => $data['fact_num'],
                    'client_tel' => $data['tel_client'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom' => '0',
                'nume' => '0',
                'paye' => '0',
                'reste' => '0',
                'dateCred' => '0',
                'dateRem' => '0',
                'idCred' => '0',
                'agent' => '0',
                'total_com' => '0',
                'is_manual' => '0',
                'fact_num' => '0',
                'client_tel' => '0',
            )];
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    if ($action == 'inventaire') {
        $dateDebut = verifyData($_POST['dateDebut']);
        $dateFin = verifyData($_POST['dateFin']);
        $getdata = $connect->query("SELECT co.Date_com as Date_com, SUM(pa.amount_Pay_Com) as payee, (co.total_com -SUM(pa.amount_Pay_Com))as reste, co.total_com as total, cl.nom_complet_client as client,co.is_print_com as is_print, co.is_deliver_com as is_deliver, us.Nom as agent, co.Id_com as IdCom FROM commande co, user us, paycom pa, client cl WHERE co.Id_com = pa.Id_com AND co.Id_user = us.Id_user AND co.Id_client_com = cl.Id_client AND co.Date_com>='" . $dateDebut . "' AND co.Date_com<='" . $dateFin . "' GROUP BY pa.Id_com ORDER BY co.Date_com ASC");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'date_inv' => $data['Date_com'],
                    'client' => $data['client'],
                    'total' => $data['total'],
                    'paye' => $data['payee'],
                    'reste' => $data['reste'],
                    'is_print' => $data['is_print'],
                    'is_deliver' => $data['is_deliver'],
                    'id_com' => $data['IdCom'],
                    'agent' => $data['agent'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'date_inv' => '0',
                'client' => '0',
                'total' => '0',
                'paye' => '0',
                'reste' => '0',
                'is_print' => '0',
                'is_deliver' => '0',
                'id_com' => '0',
                'agent' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // Ajouter une boutique annexe
    if ($action == "addBoutique") {
        $table_name = verifyData($_POST['table_name']);
        $nom = verifyData($_POST['nom']);
        $tel = verifyData($_POST['tel']);
        $ville = verifyData($_POST['ville']);
        $desc = verifyData($_POST['desc']);
        $user = intval(verifyData($_POST['user']));
        $check = $connect->query("SELECT * FROM $table_name WHERE nom_bout='" . $nom . "' AND is_active=1");
        if ($check->rowCount() == 0) {
            $createAccount = $connect->prepare("INSERT INTO $table_name(nom_bout, ville_bout, tel_bout, date_bout, dsc_bout,agent_bout) VALUES(?,?,?,NOW(),?,?)");
            if ($createAccount->execute([$nom, $ville, $tel, $desc, $user])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 97;
        }

        $connect = null;
        return;
    }

    // modifier une boutique annexe
    if ($action == "updBoutique") {
        $table_name = verifyData($_POST['table_name']);
        $nom = verifyData($_POST['nom']);
        $tel = verifyData($_POST['tel']);
        $ville = verifyData($_POST['ville']);
        $desc = verifyData($_POST['desc']);
        $idbout = intval(verifyData($_POST['idbout']));
        $check = $connect->query("SELECT * FROM $table_name WHERE nom_bout='" . $nom . "' AND is_active=1 AND id_bout!='" . $idbout . "'");
        if ($check->rowCount() == 0) {
            $createAccount = $connect->prepare("UPDATE  $table_name SET nom_bout=?, ville_bout=?,tel_bout=?,dsc_bout=? WHERE id_bout='" . $idbout . "'");
            if ($createAccount->execute([$nom, $ville, $tel, $desc])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 97;
        }

        $connect = null;
        return;
    }

    // supprimer une boutique
    if ($action == 'delBoutique') {
        $table_name = verifyData($_POST['table_name']);
        $idBou = intval(verifyData($_POST['idBou']));
        $delbout = $connect->prepare("UPDATE $table_name SET is_active=0 WHERE id_bout=?");
        if ($delbout->execute([$idBou])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // recuperation de liste des boutiques annexe
    if ($action == 'getAnnexBou') {
        $table_name = verifyData($_POST['table_name']);
        $getdata = $connect->query("SELECT * FROM $table_name b, user u WHERE b.agent_bout= u.Id_user AND b.is_active=1 ORDER BY b.id_bout DESC");
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'nom_bout' => $data['nom_bout'],
                    'tel_bout' => $data['tel_bout'],
                    'ville_bout' => $data['ville_bout'],
                    'date_bout' => $data['date_bout'],
                    'desc_bout' => $data['dsc_bout'],
                    'agent_bout' => $data['Nom'],
                    'id_bout' => $data['id_bout'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'nom_bout' => '0',
                'tel_bout' => '0',
                'ville_bout' => '0',
                'date_bout' => '0',
                'desc_bout' => '0',
                'agent_bout' => '0',
                'id_bout' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //Creation d'un bon de sortie 
    if ($action == "createBon") {
        $table_name = verifyData($_POST['table_name']);
        $id_bout = intval(verifyData($_POST['id_bout']));
        $id_client = intval(verifyData($_POST['id_client']));
        $user = intval(verifyData($_POST['user']));
        $createbon = $connect->prepare("INSERT INTO $table_name(date_bon, agent_bon, id_bout_bon,id_client) VALUES(NOW(),?,?,?)");
        if ($createbon->execute([$user, $id_bout, $id_client])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // recuperation de liste des boutiques annexe
    if ($action == 'getBonSortieInfos') {
        $table_name = verifyData($_POST['table_name']);
        $id_bout = verifyData($_POST['id_bout']);
        $type = verifyData($_POST['type']);
        if ($type == 'boutique') {
            $getdata = $connect->query("SELECT * FROM $table_name b, boutiqueannexe bo WHERE b.id_bon='" . $id_bout . "' AND bo.id_bout= b.id_bout_bon ORDER BY b.id_bon DESC LIMIT 1");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'date_bon' => $data['date_bon'],
                        'bout_nom' => $data['nom_bout'],
                        'bon_id' => $data['id_bon'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'date_bon' => '0',
                    'bout_nom' => '0',
                    'bon_id' => '0',
                )];
            }
        } else {
            $getdata = $connect->query("SELECT * FROM $table_name b, client cl WHERE b.id_bon='" . $id_bout . "' AND cl.Id_client= b.id_client ORDER BY b.id_bon DESC LIMIT 1");
            if ($getdata->rowCount() > 0) {
                $response = [];
                $i = 0;
                while ($data = $getdata->fetch()) {
                    $response[$i] = array(
                        'date_bon' => $data['date_bon'],
                        'bout_nom' => $data['nom_complet_client'],
                        'bon_id' => $data['id_bon'],
                    );
                    $i += 1;
                }
            } else {
                $response = [array(
                    'date_bon' => '0',
                    'bout_nom' => '0',
                    'bon_id' => '0',
                )];
            }
        }

        echo json_encode($response);
        $connect = null;
        return;
    }

    if ($action == 'getAllBonSortieInfos') {
        $table_name = verifyData($_POST['table_name']);
        $type = verifyData($_POST['type']);
        if ($type == 'boutique') {
            $getdata = $connect->query("SELECT us.Nom as agent_bon, bou.nom_bout as nom_bon, SUM(cnt.qte_prod_cnt) as qts_bon,b.id_bon as id_bon,b.livraire_bon as livraire, bou.id_bout as id_bout_bon, b.date_bon as date_bon,b.is_deliver_bon as is_deliver_bon, b.is_print_bon as is_print_bon FROM $table_name b, contenubon cnt, boutiqueannexe bou, user us WHERE b.id_bon = cnt.id_bon AND b.id_bout_bon = bou.id_bout AND b.agent_bon = us.Id_user GROUP BY cnt.id_bon ORDER BY b.id_bon DESC");
        } else {
            $getdata = $connect->query("SELECT us.Nom as agent_bon, cl.nom_complet_client as nom_bon, SUM(cnt.qte_prod_cnt) as qts_bon,b.id_bon as id_bon,b.livraire_bon as livraire, cl.Id_client as id_bout_bon, b.date_bon as date_bon,b.is_deliver_bon as is_deliver_bon, b.is_print_bon as is_print_bon FROM $table_name b, contenubon cnt, client cl, user us WHERE b.id_bon = cnt.id_bon AND b.id_client = cl.Id_client AND b.agent_bon = us.Id_user GROUP BY cnt.id_bon ORDER BY b.id_bon DESC");
        }
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'id_bon' => $data['id_bon'],
                    'agent_bon' => $data['agent_bon'],
                    'id_bout_bon' => $data['id_bout_bon'],
                    'is_print_bon' => $data['is_print_bon'],
                    'is_deliver_bon' => $data['is_deliver_bon'],
                    'nom_bon' => $data['nom_bon'],
                    'date_bon' => $data['date_bon'],
                    'qts_bon' => $data['qts_bon'],
                    'livraire_bon' => $data['livraire'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_bon' => '0',
                'agent_bon' => '0',
                'id_bout_bon' => '0',
                'is_print_bon' => '0',
                'is_deliver_bon' => '0',
                'nom_bon' => '0',
                'date_bon' => '0',
                'qts_bon' => '0',
                'livraire_bon' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // Recuperation des bons avec limit
    if ($action == 'getAllBonSortieInfosLimit') {
        $table_name = verifyData($_POST['table_name']);
        $type = verifyData($_POST['type']);
        $limit = verifyData($_POST['limit']);
        $search = verifyData($_POST['search']);
        if ($type == 'boutique') {
            $getdata = $connect->query("SELECT us.Nom as agent_bon, bou.nom_bout as nom_bon, SUM(cnt.qte_prod_cnt) as qts_bon,b.id_bon as id_bon,b.livraire_bon as livraire, bou.id_bout as id_bout_bon, b.date_bon as date_bon,b.is_deliver_bon as is_deliver_bon, b.is_print_bon as is_print_bon FROM $table_name b, contenubon cnt, boutiqueannexe bou, user us WHERE b.id_bon = cnt.id_bon AND b.id_bout_bon = bou.id_bout AND b.agent_bon = us.Id_user $search GROUP BY cnt.id_bon ORDER BY b.id_bon DESC $limit");
        } else {
            $getdata = $connect->query("SELECT us.Nom as agent_bon, cl.nom_complet_client as nom_bon, SUM(cnt.qte_prod_cnt) as qts_bon,b.id_bon as id_bon,b.livraire_bon as livraire, cl.Id_client as id_bout_bon, b.date_bon as date_bon,b.is_deliver_bon as is_deliver_bon, b.is_print_bon as is_print_bon FROM $table_name b, contenubon cnt, client cl, user us WHERE b.id_bon = cnt.id_bon AND b.id_client = cl.Id_client AND b.agent_bon = us.Id_user $search GROUP BY cnt.id_bon ORDER BY b.id_bon DESC $limit");
        }
        if ($getdata->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getdata->fetch()) {
                $response[$i] = array(
                    'id_bon' => $data['id_bon'],
                    'agent_bon' => $data['agent_bon'],
                    'id_bout_bon' => $data['id_bout_bon'],
                    'is_print_bon' => $data['is_print_bon'],
                    'is_deliver_bon' => $data['is_deliver_bon'],
                    'nom_bon' => $data['nom_bon'],
                    'date_bon' => $data['date_bon'],
                    'qts_bon' => $data['qts_bon'],
                    'livraire_bon' => $data['livraire'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'id_bon' => '0',
                'agent_bon' => '0',
                'id_bout_bon' => '0',
                'is_print_bon' => '0',
                'is_deliver_bon' => '0',
                'nom_bon' => '0',
                'date_bon' => '0',
                'qts_bon' => '0',
                'livraire_bon' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    //remplire le contenu du bon de sortie 
    if ($action == "fill_bon") {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['idProd']));
        $qts = verifyData($_POST['qts']);
        $idBon = intval(verifyData($_POST['idBon']));
        $fillBon = $connect->prepare("INSERT INTO $table_name(id_prod_cnt, qte_prod_cnt, id_bon) VALUES(?,?,?)");
        if ($fillBon->execute([$idProd, $qts, $idBon])) {
            $connect->query("UPDATE stock SET Qt_pro=(Qt_pro-'" . $qts . "') WHERE Id_pro='" . $idProd . "'");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation du contenu de bon de sortie
    if ($action == "getBonContent") {
        $table_name = verifyData($_POST['table_name']);
        $idBon = intval(verifyData($_POST['idBon']));
        $type = verifyData($_POST['type']);
        if ($type == 'boutique') {
            $bonCnt = $connect->query("SELECT b.id_bon as idBon, cnt.id_prod_cnt as idProd, cl.id_bout as idBout, cnt.qte_prod_cnt as quantite, pr.Nom_pro as designation FROM bonsortie b, produits pr, contenubon cnt, boutiqueannexe cl WHERE b.id_bon = cnt.id_bon AND cnt.id_prod_cnt = pr.Id_pro AND b.id_bout_bon = cl.id_bout AND b.id_bon ='" . $idBon . "'");
        } else {
            $bonCnt = $connect->query("SELECT b.id_bon as idBon, cnt.id_prod_cnt as idProd, cl.Id_client as idBout, cnt.qte_prod_cnt as quantite, pr.Nom_pro as designation FROM bonsortie b, produits pr, contenubon cnt, client cl WHERE b.id_bon = cnt.id_bon AND cnt.id_prod_cnt = pr.Id_pro AND b.id_client = cl.Id_client AND b.id_bon ='" . $idBon . "'");
        }
        if ($bonCnt->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $bonCnt->fetch()) {
                $response[$i] = array(
                    'qts_ctn' => $data['quantite'],
                    'id_prod_ctn' => $data['idProd'],
                    'id_bon_ctn' => $data['idBon'],
                    'prod_nom_bon_ctn' => $data['designation'],
                    'id_bout_ctn' => $data['idBout'],
                    'qts_total_ctn' => '0',
                    'idClient' => '0',
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'qts_ctn' => '0',
                'id_prod_ctn' => '0',
                'id_bon_ctn' => '0',
                'prod_nom_bon_ctn' => '0',
                'id_bout_ctn' => '0',
                'qts_total_ctn' => '0',
                'idClient' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    //supprimer un produit dans une vente
    if ($action == 'deleteBonItem') {
        $table_name = verifyData($_POST['table_name']);
        $idBon = intval(verifyData($_POST['idBon']));
        $idProd = intval(verifyData($_POST['idProd']));
        $quantite = intval(verifyData($_POST['quantite']));
        $del = $connect->prepare("DELETE FROM $table_name WHERE id_prod_cnt =? AND id_bon=?");
        if ($del->execute([$idProd, $idBon])) {
            $updStock = $connect->prepare("UPDATE stock SET Qt_pro = (Qt_pro+'" . $quantite . "') WHERE Id_pro =?");
            if ($updStock->execute([$idProd])) {
                echo 1;
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Supprimer toute le bon 
    if ($action == 'deleteBon') {
        $table_name = verifyData($_POST['table_name']);
        $idBon = intval(verifyData($_POST['idBon']));
        $getBonCont = $connect->query("SELECT * FROM contenubon WHERE id_bon='" . $idBon . "'");
        while ($vent = $getBonCont->fetch()) {
            $updStock = $connect->query("UPDATE stock SET Qt_pro = (Qt_pro+'" . $vent['qte_prod_cnt'] . "') WHERE Id_pro ='" . $vent['id_prod_cnt'] . "'");
            $del = $connect->query("DELETE FROM contenubon WHERE id_prod_cnt ='" . $vent['id_prod_cnt'] . "' AND id_bon ='" . $idBon . "'");
        }
        $dele = $connect->prepare("DELETE FROM $table_name WHERE id_bon =?");
        if ($dele->execute([$idBon])) {
            $deleBonPay = $connect->query("DELETE FROM paycom WHERE Id_com ='" . $idBon . "' AND type_Pay_Com='Bon de sortie'");
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
    // Notifier impression de commande
    if ($action == "noticeBonPrint") {
        $idBon = intval(verifyData($_POST['idBon']));
        $livraire = verifyData($_POST['livraire']);
        $table_name = verifyData($_POST['table_name']);
        $updBon = $connect->prepare("UPDATE $table_name SET is_print_bon=1,livraire_bon=? WHERE id_bon=?");
        if ($updBon->execute([$livraire, $idBon])) {
            echo '1';
        } else {
            echo '0';
        }
        $connect = null;
        return;
    }

    //recuperer les infos de la vente pour bon de livraison
    if ($action == "getVenteInfosForBon") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));

        $getComInfos = $connect->query("SELECT * FROM $table_name com, client cl WHERE com.Id_com='" . $idCom . "' AND cl.Id_client = com.Id_client_com");
        if ($getComInfos->rowCount() > 0) {
            $backInfos = $getComInfos->fetch();
            $response = [array(
                'dateVente' => $backInfos['Date_com'],
                'clientName' => $backInfos['nom_complet_client'] . '-' . $backInfos['Id_client_com'],
                'venteId' => $backInfos['Id_com'],
            )];
        } else {
            $response = [array(
                'dateVente' => '0',
                'clientName' => '0',
                'venteId' => '0',
            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // ajout de la somme payer par un bon client
    if ($action == "addBonClientPay") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $idBon = intval(verifyData($_POST['idBon']));
        $somme = intval(verifyData($_POST['somme']));
        $user = intval(verifyData($_POST['user']));
        $setPayBon = $connect->prepare("INSERT INTO $table_name(Id_com_rev,somme_rev, id_bon_rev, date_rev,agent_rev) VALUES(?,?,?,NOW(),?)");
        if ($setPayBon->execute([$idCom, $somme, $idBon, $user])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // Update la somme payer par un bon client
    if ($action == "updBonClientPay") {
        $table_name = verifyData($_POST['table_name']);
        $idBon = intval(verifyData($_POST['idBon']));
        $somme = intval(verifyData($_POST['somme']));
        $getinfos = $connect->query("SELECT id_rev,Id_com_rev,agent_rev FROM reviewfactu WHERE id_bon_rev='" . $idBon . "' ORDER BY id_rev DESC LIMIT 1");
        if ($an = $getinfos->fetch()) {
            $id_rev = $an['id_rev'];
            $id_com = $an['Id_com_rev'];
            $user = $an['agent_rev'];
            $updPayBon = $connect->prepare("UPDATE $table_name SET somme_rev=? WHERE id_rev=?");
            if ($updPayBon->execute([$somme, $id_rev])) {
                $updComPay = $connect->prepare("INSERT INTO paycom(type_Pay_Com, amount_Pay_Com, Id_com, last_update_Pay_Com, user_com) VALUES('Bon de sortie',?,?,NOW(),?)");
                if ($updComPay->execute([$somme, $id_com, $user])) {
                    echo 1;
                } else {
                    echo 0;
                }
            } else {
                echo 0;
            }
        } else {
            echo 0;
        }

        $connect = null;
        return;
    }

    // recupere la somme payer par un bon client
    if ($action == "getBonClientPay") {
        $table_name = verifyData($_POST['table_name']);
        $idBon = intval(verifyData($_POST['idBon']));
        $getsomme = $connect->query("SELECT somme_rev FROM reviewfactu WHERE id_bon_rev='" . $idBon . "'");
        if ($an = $getsomme->fetch()) {
            echo $an['somme_rev'];
        } else {
            echo -1;
        }
        $connect = null;
        return;
    }

    // recuperer le numero de paiement
    if ($action == "getpayNumber") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));

        $getPay = $connect->query("SELECT * FROM  paycom  WHERE Id_com='" . $idCom . "' AND (type_Pay_Com ='Orange Money' OR type_Pay_Com ='Moov Money' OR type_Pay_Com ='Chèque')");

        $status = 0;
        if ($getPay->rowCount() > 0) {

            $i = 0;
            $response = [];
            $cheker = [];
            while ($Paydata = $getPay->fetch()) {
                $payNumId = implode(',', $cheker);
                $getNumb = $connect->query("SELECT * FROM numeropay n, paycom pa WHERE n.id_com='" . $idCom . "' AND pa.id_Pay_Com = '" . $Paydata['id_Pay_Com'] . "' AND n.id_num NOT IN('" . $payNumId . "')");
                $status = 1;

                if ($data = $getNumb->fetch()) {
                    array_push($cheker, $data['id_num']);
                    $response[$i] = array(
                        'number_num' => $data['number_num'] . "=>" . $data['id_Pay_Com'],
                    );
                }
                $i += 1;
            }
        } else {
            $status = 0;
            $response = [array(
                'number_num' => 0,

            )];
        }
        echo json_encode(['statut' => $status, 'donnee' =>  $response]);
        $connect = null;
        return;
    }

    // recuperer idBon pour les bon de sortie cote client
    if ($action == "getClientIdBon") {
        $table_name = verifyData($_POST['table_name']);
        $idClient = intval(verifyData($_POST['idClient']));
        $type = verifyData($_POST['type']);
        if ($type == 'boutique') {
            $getIdBon = $connect->query("SELECT id_bon FROM $table_name WHERE id_bout_bon='" . $idClient . "' ORDER BY id_bon DESC LIMIT 1");
        } else {
            $getIdBon = $connect->query("SELECT id_bon FROM $table_name WHERE id_client='" . $idClient . "' ORDER BY id_bon DESC LIMIT 1");
        }
        if ($an = $getIdBon->fetch()) {
            echo $an['id_bon'];
        } else {
            echo -1;
        }
        $connect = null;
        return;
    }

    //Creation d'un bon de sortie 
    if ($action == "addPayNumber") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $tel = verifyData($_POST['tel']);
        $user = intval(verifyData($_POST['user']));
        $createbon = $connect->prepare("INSERT INTO $table_name(number_num, id_com, agent) VALUES(?,?,?)");
        if ($createbon->execute([$tel, $idCom, $user])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    // Verification de compte de versement
    if ($action == "checkVersement") {
        $table_name = verifyData($_POST['table_name']);
        $idCom = intval(verifyData($_POST['idCom']));
        $id_cpt = intval(verifyData($_POST['id_cpt']));
        $totalPay = intval(verifyData($_POST['totalPay']));
        $idUser = intval(verifyData($_POST['idUser']));
        // Verification de l'existance du compte
        $checkExistCpt = $connect->query("SELECT * FROM compteversement WHERE id_cpt=$id_cpt");
        if ($checkExistCpt->rowCount() == 0) {
            echo 404;
        } else {
            // Verification de la dispinibilite de la somme a decaisser
            $accountVal = $checkExistCpt->fetch();
            if (intval($accountVal['montant_cpt']) >= intval($totalPay)) {
                if ($connect->query("UPDATE compteversement SET montant_cpt =(montant_cpt-$totalPay) WHERE  id_cpt=$id_cpt")) {
                    $addTrack = $connect->prepare("INSERT INTO $table_name(id_cpt_sc, id_com_sc, somme_sc, id_user_sc,date_sc) VALUES(?,?,?,?,NOW())");
                    if ($addTrack->execute([$id_cpt, $idCom, $totalPay, $idUser])) {
                        echo 1;
                    }
                } else {
                    echo 0;
                }
            } else {
                echo 400;
            }
        }
        $connect = null;
        return;
    }
    //recuperation de la list des achat avec compte de versement
    if ($action == 'getTrackVersement') {
        $table_name = verifyData($_POST['table_name']);
        $id_cpt = intval(verifyData($_POST['id_cpt']));
        $getAchatVers = $connect->query("SELECT * FROM $table_name sc, user u WHERE u.Id_user=sc.id_user_sc AND sc.id_cpt_sc='" . $id_cpt . "'");
        if ($getAchatVers->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getAchatVers->fetch()) {
                $response[$i] = array(
                    'idCom' => $data['id_com_sc'],
                    'dateCom' => $data['date_sc'],
                    'agent' => $data['Nom'],
                    'somme' => $data['somme_sc'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'idCom' => '0',
                'dateCom' => '0',
                'agent' => '0',
                'somme' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }
    // ajout d'un produit usé
    if ($action == "addProduitUse") {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['idProd']));
        $prix = verifyData($_POST['prix']);
        $qts = verifyData($_POST['qts']);
        $desc = verifyData($_POST['desc']);
        $user = intval(verifyData($_POST['user']));

        $setpro = $connect->prepare("INSERT INTO $table_name(id_pro,qts, prix,date_ajout,dsc,id_user) VALUES(?,?,?,NOW(),?,?)");
        if ($setpro->execute([$idProd, $qts, $prix, $desc, $user])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //recuperation de la liste des produits usés
    if ($action == 'getProdutsUse') {
        $table_name = verifyData($_POST['table_name']);
        $getprodUse = $connect->query("SELECT * FROM $table_name ps, user u, produits p, categorie ca WHERE u.Id_user=ps.id_user AND ps.id_pro = p.Id_pro AND p.Id_cat = ca.Id_cat");
        if ($getprodUse->rowCount() > 0) {
            $response = [];
            $i = 0;
            while ($data = $getprodUse->fetch()) {
                $response[$i] = array(
                    'designation' => $data['Nom_pro'],
                    'agent' => $data['Nom'],
                    'prix' => $data['prix'],
                    'categorie' => $data['Nom_cat'],
                    'date' => $data['date_ajout'],
                    'desc' => $data['dsc'],
                    'qts' => $data['qts'],
                    'id' => $data['id'],
                    'idProd' => $data['Id_pro'],
                    'idCat' => $data['Id_cat'],
                );
                $i += 1;
            }
        } else {
            $response = [array(
                'designation' => '0',
                'agent' => '0',
                'prix' => '0',
                'categorie' => '0',
                'date' => '0',
                'desc' => '0',
                'qts' => '0',
                'id' => '0',
                'idProd' => '0',
                'idCat' => '0',

            )];
        }
        echo json_encode($response);
        $connect = null;
        return;
    }

    // modification d'un  produit use
    if ($action == "modifyProduitUse") {
        $table_name = verifyData($_POST['table_name']);
        $idProd = intval(verifyData($_POST['idProd']));
        $id_prod_use = intval(verifyData($_POST['id_prod_use']));
        $prix = verifyData($_POST['prix']);
        $qts = verifyData($_POST['qts']);
        $desc = verifyData($_POST['desc']);
        $user = intval(verifyData($_POST['user']));

        $updpro = $connect->prepare("UPDATE $table_name SET id_pro='" . $idProd . "',qts='" . $qts . "', prix='" . $prix . "',date_ajout=Now(),dsc='" . $desc . "',id_user='" . $user . "' WHERE id=?");
        if ($updpro->execute([$id_prod_use,])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }

    //Suppression d'un  produit use
    if ($action == 'deleteProduitUse') {
        $table_name = verifyData($_POST['table_name']);
        $idProdUse = intval(verifyData($_POST['idProdUse']));
        $dele = $connect->prepare("DELETE FROM $table_name WHERE id =?");
        if ($dele->execute([$idProdUse])) {
            echo 1;
        } else {
            echo 0;
        }
        $connect = null;
        return;
    }
} catch (PDOException $e) {
    echo "Connexion echoué !! " . $e->getMessage();
}

function verifyData($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}
function pw($cnib)
{
    $pre = "SWPB";
    $time = date('s');
    $sufList = str_split($cnib);
    $suf = $sufList[count($sufList) - 3] . $sufList[count($sufList) - 1] . $sufList[count($sufList) - 2];
    return $pre . $time . $suf;
}