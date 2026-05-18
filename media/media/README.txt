Coloca aqui archivos publicitarios o configura enlaces en ads-config.js.

Para archivos locales, usa el nombre de la terminal como prefijo:
- marcala001.jpg
- marcala002.mov
- marcala003.mp4
- lapaz001.jpg

Despues ejecuta generar-ads.ps1 desde la carpeta D:\BusBoard.
Ese script actualiza media\ads.js con todos los archivos encontrados.

Para videos de YouTube o enlaces de publicidad, edita ads-config.js:
- type: "youtube" para videos embebidos desde YouTube
- type: "link" para anuncios de texto con enlace
- stations: ["Marcala"] o ["all"]
- link: pagina del anunciante

La pantalla filtra automaticamente por la terminal activa y rota infinitamente.
Si no hay anuncios para esa terminal, muestra anuncios de ejemplo.
