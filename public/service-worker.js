self.addEventListener('install', function(event) {
    console.log('Service Worker installing.');
    event.waitUntil(
      caches.open('static-v1').then(function(cache) {
        return cache.addAll([
          '/',                            // ルートページ
          '/assets/application-872040f00311fdff41962b578e80cc09826b61b7d90ef9a60da8481b3fbad00a.css',      // プリコンパイルされたCSS
          '/assets/application-d317869c6c6b6332709fca2200adb557b0eb523b2ddb5b446fe1b4de433dc801.js',       // プリコンパイルされたJS
        ]);
      })
    );
  });
  
  self.addEventListener('fetch', function(event) {
    event.respondWith(
      caches.match(event.request).then(function(response) {
        return response || fetch(event.request);
      })
    );
  });