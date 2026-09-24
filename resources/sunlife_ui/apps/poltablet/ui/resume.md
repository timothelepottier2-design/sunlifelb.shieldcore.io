# Résumé des modifications (depuis le plan de refonte UI)

Document regroupant les changements effectués sur la tablette police après la refonte de l’interface.

---

## 1. Mode photo réaliste

- **Viseur dans l’écran** : la vue caméra s’affiche dans la zone écran de la tablette (pas en plein écran).
- **Transparence** : seul l’écran devient transparent pour la visée ; le cadre (device) reste opaque.
  - Implémentation : en mode caméra, `.tablet-device` est masqué et un overlay `#cameraBezel` affiche uniquement la bordure + viseur + bouton, avec fond transparent.
- **Son** : son de shutter à la prise de photo.
- **Capture** : Entrée ou clic gauche pour capturer (sans déclencher de coup de poing).
  - Côté client : `DisableControlAction(0, 24)` et `(0, 25)` pour bloquer attaque/viser, et `IsDisabledControlJustPressed(0, 24)` pour détecter le clic.
- **Vue** : passage automatique en première personne à l’entrée en mode photo, et restauration de la vue précédente à la sortie (capture ou ESC).

**Fichiers** : `client/main.lua`, `ui/index.html` (bloc `#cameraBezel`), `ui/style.css` (`.camera-bezel`, `.tablet-device.camera-mode-active`), `ui/script.js` (hideForCamera, showAfterCamera, cancelCamera).

---

## 2. Casiers

- **Libellé formulaire** : le label affiché « Type d’infraction » a été remplacé par « Agent(s) présent(s) » (placeholder : « Nom des agents présents… »). Les noms de variables / IDs HTML n’ont pas été modifiés ; un commentaire signale que ce champ correspond aux agents présents.
- **Photos / preuves** :
  - Suppression de l’input URL. Section « Photos / Preuves » avec grille de miniatures et bouton « + Ajouter depuis la galerie » (comme pour les profils citoyens).
  - Les photos choisies sont envoyées à la création du casier et stockées en BDD (colonne `images`, JSON).
  - En détail d’un casier, les photos sont affichées ; clic sur une photo → lightbox (agrandir / fermer en cliquant à côté).
- **Modification** : bouton « Modifier » dans le détail d’un casier, visible uniquement si `playerGradeLevel >= EDIT_MIN_GRADE` (côté serveur : `EDIT_MIN_GRADE`, côté client : même seuil). Pré-remplissage du formulaire et envoi via `editCasier`.

**Fichiers** : `ui/index.html` (formulaire casier, grille photos), `ui/style.css` (`.casier-photos-section`, `.casier-photos-grid`, `.casier-photo-thumb`), `ui/script.js` (galerie, rendu photos, détail avec lightbox, bouton Modifier), `server/main.lua` (colonne `images`, SELECT/INSERT/UPDATE, event `editCasier`, `GetPlayerGradeLevel`).

---

## 3. Mandats d’arrêt

- **Photos / preuves** :
  - Suppression du textarea « Images (une URL par ligne) ». Même principe que les casiers : section « Photos / Preuves », grille de miniatures, bouton « + Ajouter depuis la galerie » pour la création et la modification.
  - Les URLs sont stockées en BDD et affichées dans le détail du mandat.
- **Lightbox** : clic sur une photo en détail mandat ouvre la lightbox (agrandir / fermer en cliquant sur l’overlay).
- **Modification** : bouton « Modifier » dans le détail du mandat, même règle de grade que pour les casiers ; formulaire pré-rempli et envoi via `editWarrant`.

**Fichiers** : `ui/index.html` (formulaire mandats : grille `#warrantsFormPhotosGrid`), `ui/script.js` (`warrantsFormPhotos`, `warrantsPhotosRender`, `openGalleryPickerForWarrants`, reset/submit/edit, lightbox sur images détail), `server/main.lua` (event `editWarrant`).

---

## 4. Grade et modification (casiers + mandats)

- **Serveur** : constante `EDIT_MIN_GRADE` (ex. 7 ou 8). Les events `editCasier` et `editWarrant` vérifient `GetPlayerGradeLevel(src) >= EDIT_MIN_GRADE` ; sinon envoi d’un résultat `success = false, reason = "grade"`.
- **Client** : `playerGradeLevel` est rempli à l’ouverture de la tablette (depuis `data.player.grade_level`). Les boutons « Modifier » (casier et mandat) ne sont rendus que si `playerGradeLevel >= EDIT_MIN_GRADE` (même valeur que côté serveur pour cohérence).
- Les logs temporaires « grade getsu » ont été retirés après vérification.

**Fichiers** : `server/main.lua` (`EDIT_MIN_GRADE`, `GetPlayerGradeLevel`, vérifs dans `editCasier` / `editWarrant`), `ui/script.js` (affichage conditionnel des boutons Modifier).

---

## 5. Corrections techniques

- **Transparence mode caméra** : après essais avec `background`, `background-clip`, `mask-image`, la solution retenue est de cacher tout le device et d’afficher uniquement l’overlay `#cameraBezel` (bordure + contenu utile, fond transparent).
- **Clic capture** : utilisation de `IsDisabledControlJustPressed(0, 24)` au lieu de `IsControlJustPressed(0, 24)` pour que le clic gauche soit pris en compte même quand l’action « coup de poing » est désactivée.
- **Photos casier en détail** : ajout de la colonne `images` en BDD si nécessaire, inclusion dans les SELECT et dans `EnrichCasierRows`, et côté NUI parsing de `c.images` (string JSON ou tableau) pour afficher les miniatures avec `onclick="openLightbox(...)"`.

---

## Fichiers modifiés (référence rapide)

| Fichier | Principales modifs |
|--------|---------------------|
| `client/main.lua` | Mode photo, contrôles, vue 1ère personne, NUI callbacks edit |
| `server/main.lua` | `EDIT_MIN_GRADE`, `GetPlayerGradeLevel`, events editCasier/editWarrant, colonne `images` casier, SELECT/INSERT/UPDATE |
| `ui/index.html` | Formulaire casier (label, section photos), formulaire mandats (grille photos), `#cameraBezel` |
| `ui/style.css` | Mode caméra (camera-bezel, tablet-device.camera-mode-active), grille photos casier/mandat |
| `ui/script.js` | Galerie pour casiers/mandats, lightbox, boutons Modifier (grade), edit/prefill, reset formulaires |

---

*Dernière mise à jour : résumé des changements depuis le plan de refonte UI.*
