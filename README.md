NC 3.0 — RECONSTRUCTION VISUELLE

Publier Library-3.0.lua et exemple.lua a la racine de AGTVoff/ncV3 (branche main).
Le fichier exemple charge exactement ce chemin.

API originale preservee : Window, Page, SubPage, Section, Toggle, Slider, Dropdown,
Textbox, Label, Button, Colorpicker, Keybind, Settings, configurations et widgets.
Alias supplementaires : CreateWindow, CreateTab, CreateSubTab.

Refonte : structure Window reconstruite, navigation laterale, bandeau interne,
sous-onglets en haut, cartes, interrupteurs a curseur, boutons et champs plus hauts,
sliders avec valeurs hors de la barre. Logo original embarque.
Le chargement du logo requiert getcustomasset/getsynasset et les API fichiers.
La library conserve les dependances d'environnement du fichier original.
Les widgets annexes et certaines fenetres contextuelles gardent leur structure d'origine.

Verification : generation des fichiers, presence des methodes et integrite du logo.
Pas de test d'execution Luau/Roblox dans cet environnement.
Compatibilite et geometrie des popups, des widgets et des petits ecrans a tester.
