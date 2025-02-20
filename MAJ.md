1. Forker le Repo :

Allez sur la page du repo GitHub que vous souhaitez forker.
Cliquez sur le bouton "Fork" en haut à droite de la page. Cela créera une copie du repo sous votre compte GitHub.
Cloner Votre Fork :

Allez sur votre fork du repo sur GitHub.
Cliquez sur le bouton "Code" et copiez l'URL du repo.
Ouvrez votre terminal et exécutez la commande suivante pour cloner le repo sur votre machine locale :
```bash
git clone https://github.com/VOTRE_NOM_UTILISATEUR/NOM_DU_REPO.git
```
Ajouter le Repo Original comme Remote :

Naviguez dans le répertoire du repo cloné :

```bash
cd bacass_IBP
```
Ajoutez le repo original comme remote (nommé upstream par convention) :

git remote add upstream https://github.com/NOM_UTILISATEUR_ORIGINAL/NOM_DU_REPO.git
Vérifier les Remotes :

Vous pouvez vérifier que les remotes ont été correctement ajoutés en exécutant :
```bash
git remote -v
```

Vous devriez voir deux remotes : origin (votre fork) et upstream (le repo original).
Pull les Mises à Jour du Repo Original :

Pour récupérer les dernières mises à jour du repo original, exécutez :

```bash
git fetch upstream
```

Ensuite, mergez les changements de la branche main (ou master) du repo original dans votre branche locale :

```bash
git checkout master
git merge upstream/master
```

Pousser les Changements vers Votre Fork :

Après avoir mergé les changements, poussez-les vers votre fork :

```bash
git push origin master
```

En suivant ces étapes, vous pourrez maintenir votre fork à jour avec le repo original tout en faisant vos modifications personnelles.