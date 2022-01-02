# Data base driven website for health insurance company

## installation
* Windows
    ```bash
    $ py -m venv venv
    $ source venv/Scripts/activate
    $ pip install -r requirements.txt
    ```

* Linux
    ```bash
    $ virtualenv venv
    $ source venv/bit/activate
    $ pip install -r requirements.txt
    ```


## Running command
*
    ```
    $ python main/views.py 
    ```


## Note
- add file __database_secrets.py__ to main folder
    ```py
    HOST = 'YOUR_HOST'
    DATABASE = 'YOUR_DATABASE'
    USER = 'YOUR_USER'
    PASSWORD = 'YOUR_PASSWORD'
    ```