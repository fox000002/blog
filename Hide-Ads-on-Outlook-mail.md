The class and id are dynamic on https://outlook.live.com/mail. To hide the ads, it has to locate that by index. 

```
    // ==UserScript==
    // @name         outlook
    // @namespace    http://tampermonkey.net/
    // @version      0.1
    // @description  try to take over the world!
    // @author       You
    // @match        https://outlook.live.com/mail/*
    // @grant        none
    // @require https://code.jquery.com/jquery-1.12.4.min.js
    // ==/UserScript==
    (function() {
        'use strict';
        $(function() {
           var timer = setInterval(function() {
               $('div#app > div > div:nth-child(2) > div > div > div:nth-child(4)').hide();
               if ($('div#app > div > div:nth-child(2) > div > div > div:nth-child(4)').css('display') === 'none') {
                  clearInterval(timer);
               }
           }, 100);
        });
    })();
```
