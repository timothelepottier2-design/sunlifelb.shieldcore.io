# Carte « Agents en ville »

## Calibrage par points de contrôle (recommandé)

Pour que le point rouge soit exactement à ta position, tu peux calibrer la carte avec des points de référence.

1. **Coords jeu** : déjà renseignées dans `config.lua` (Config.MapControlPoints) pour 7 repères (Del Perro P, Port of South LS L, East LS L, Tongva Hills G, Grand Senora Desert S, Mount Gordo M, Paleto Bay O).

2. **Coords image (px, py)** : ouvre ton **map.png** dans un logiciel (Paint, GIMP, Photoshop, etc.). L’origine est le **haut-gauche** (0,0) ; **px** augmente vers la droite, **py** vers le bas. Pour chaque repère, place le curseur sur la lettre indiquée et note **px** et **py** (souvent affichés en bas ou dans la barre d’info). Remplis les champs **px** et **py** dans `Config.MapControlPoints` pour au moins 2 points (idéalement 3 ou plus répartis sur la carte).

3. **Dimensions de l’image** : vérifie **Config.MapImageSize** (width, height). Par défaut 2048×2048. Adapte si ton image a une autre taille.

Dès que au moins 2 points ont **px** et **py** renseignés, la ressource calcule toute seule la transformation (scale + offset par axe) et place les agents au bon endroit.

## Sans calibrage

Si tu ne remplis pas les px/py, la carte utilise **MapLinear**, **MapYFlipped** et **MapSwapXY** comme avant (placement approximatif).

## Image et bornes

- Remplace **map.png** par ton image de la carte GTA V. Fallback : **map.svg**.
- **Config.MapBounds** : zone monde couverte par l’image (minX, maxX, minY, maxY). Ex. -4000 à 4000.
