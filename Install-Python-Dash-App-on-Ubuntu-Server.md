Install Python Dash App on Ubuntu Server
---

### Environment

- Ubuntu 18.04
- Apache2
- WSGI

### Dash App

- https://github.com/plotly/dash-recipes/tree/master/multi-page-app

### Install Python & Apache2

```
sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt-get install mysql-client mysql-server

sudo apt-get install python3.6 python3.6-dev

sudo apt-get install apache2 apache2-dev
```

#### Install pip3.6

```
curl https://bootstrap.pypa.io/get-pip.py | sudo python3.6
```

#### Install mod_wsgi

```
sudo pip3.6 install mod_wsgi
```

### Enable WSGI

#### Create WSGI mod

`sudo nano /etc/apache2/mods-available/wsgi.load`

Add the output of command `mod_wsgi-express module-config` to the file. It should looks like the following two lines.

```
LoadModule wsgi_module "/usr/local/lib/python3.6/dist-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so"
WSGIPythonHome "/usr"
```

#### Enable module wsgi

```
sudo a2enmod wsgi

sudo service apache2 restart
```

### Deploy a Flask App

```
sudo pip3.6 install Flask
```

```
sudo nano /etc/apache2/sites-available/FlaskApp.conf
```

```
<VirtualHost *:80>
   ServerName yourservername
   ServerAdmin youremail@email.com
   WSGIScriptAlias / /var/www/FlaskApp/FlaskApp.wsgi
   <Directory /var/www/FlaskApp/FlaskApp/>
        Order allow,deny
        Allow from all
   </Directory>
   ErrorLog ${APACHE_LOG_DIR}/FlaskApp-error.log
   LogLevel warn
   CustomLog ${APACHE_LOG_DIR}/FlaskApp-access.log combined
</VirtualHost>
```

```
sudo a2ensite FlaskApp
```

```
sudo mkdir -p /var/www/FlaskApp/FlaskApp
```

*The rest steps for deploying the Flask App are ignored here, since they are overwritten when deploying the Dash App. Check [1] for more details.*

#### Remove default enabled sites

If default site is enable, it may show the default HTML page instead of Flask page.

```
sudo a2dissite 000-default
```


### Deploy the Dash App

#### Install Dash packages

```
sudo pip3.6 install dash==0.30.0  # The core dash backend
sudo pip3.6 install dash-html-components==0.13.2  # HTML components
sudo pip3.6 install dash-core-components==0.38.0  # Supercharged components
sudo pip3.6 install dash-table==3.1.6  # Interactive DataTable component (new!)
```

#### Upload the code

Upload code files in https://github.com/plotly/dash-recipes/tree/master/multi-page-app to `/var/www/FlaskApp/FlaskApp`.

The directory structure is as following:

```
/var/www/FlaskApp
├── FlaskApp
│   ├── app.py
│   ├── apps
│   │   ├── app1.py
│   │   ├── app2.py
│   │   ├── __init__.py
│   ├── index.py
│   ├── multi-page-app.gif
│   └── static
│       └── base.css
└── FlaskApp.wsgi
```

#### Update app.py

Since it run with WSGI, `os.getcwd()` does not work any more. Change it to absolute path and fix the parameter `<path>` syntax.

If this is not corrected, files such as `/static/base.css` will throw `404`.

```
sudo nano /var/www/FlaskApp/FlaskApp/app.py
```

```
import dash
import os

from flask import send_from_directory


app = dash.Dash()
server = app.server
app.config.supress_callback_exceptions = True

external_css = [
    'https://codepen.io/chriddyp/pen/bWLwgP.css',
    '/static/base.css'
]
for css in external_css:
    app.css.append_css({"external_url": css})

@app.server.route('/static/<path>')
def static_file(path):
    static_folder = os.path.join('/var/www/FlaskApp/FlaskApp/', 'static')
    return send_from_directory(static_folder, path)
```

#### Update FlaskApp.wsgi

```
sudo nano /var/www/FlaskApp/FlaskApp.wsgi
```

```
#!/usr/bin/python3.6
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/FlaskApp/FlaskApp/")

from index import app
application = app.server
```

### References

[1] https://pythonprogramming.net/basic-flask-website-tutorial/?completed=/practical-flask-introduction/

[2] https://dash.plot.ly/installation

[3] https://plot.ly/dash/deployment

[4] https://help.pythonanywhere.com/pages/Flask/

[5] https://stackoverflow.com/questions/50724859/call-local-css-files-in-dash-app
