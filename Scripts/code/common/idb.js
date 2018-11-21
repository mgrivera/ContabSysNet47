

var Indexed_db = (function () {
    var iDB = {};
    var datastore = null;

    /**
     * Open a connection to the datastore.
     */
    iDB.open = function (callback) {
        // Database version.
        var dbVersion = 1;

        // Open a connection to the datastore.
        var request = indexedDB.open('dbContab', dbVersion);

        // Handle datastore upgrades.
        request.onupgradeneeded = function (e) {
            var db = e.target.result;

            e.target.transaction.onerror = function (e) {
                // Execute the callback; 2nd parameter is error (which is null) 
                callback(null, e);
            }; 

            if (e.oldVersion < dbVersion) {
                // Create a new datastore.
                var storeCompanias = db.createObjectStore("companias", { keyPath: "id", autoincrement: false, unique: true });
                var storeCajasChicas = db.createObjectStore("cajasChicas", { keyPath: "id", autoincrement: false, unique: true });
                var storeRubrosCajaChica = db.createObjectStore("rubrosCajaChica", { keyPath: "id", autoincrement: false, unique: true });
            }
        };

        // Handle successful datastore access.
        request.onsuccess = function (e) {
            // Get a reference to the DB.
            datastore = e.target.result;

            // Execute the callback; 2nd parameter is error (which is null) 
            callback(datastore, null);
        };

        // Handle errors when opening the datastore.
        request.onerror = function (e) {
            // Execute the callback; 2nd parameter is error (which is null) 
            callback(null, e);
        };
    };



    // para eliminar todos los records de un object store 

    iDB.clearObjectStoreData = function (db, objectStoreName, callback) {

        var transaction = db.transaction(objectStoreName, "readwrite");

        //// report on the success of opening the transaction
        //transaction.oncomplete = function (event) {

        //};

        transaction.onerror = function (e) {
            callback(null, e);
        };

        // create an object store on the transaction
        var objectStore = transaction.objectStore(objectStoreName);

        // clear all the data out of the object store
        var objectStoreRequest = objectStore.clear();

        objectStoreRequest.onsuccess = function (e) {
            // report the success of our clear operation
            callback(datastore, null);
        };
    }


    // para agregar una lista (array of objects) a un object store ... 

    iDB.writeListToObjectStore = function (db, objectStoreName, items, callback) {

        // nótese este código que conseguimos en la Web, para agregar muchos registros a un object store 
        // lo que se logra con este código, es agregar un próximo registro, solo cuando el anterior se ha 
        // agregado; recuérdese que cada uno se agrega en forma asyncrona ... 
        // lamentablemente, en IDB no hay una forma para agregar muchos registros de una vez (bulk insert) 

        db.onerror = function (e) {
            callback(null, e);
        };

        var transaction = db.transaction(objectStoreName, "readwrite");
        var itemStore = transaction.objectStore(objectStoreName);

        var i = 0; 
        putNext();

        function putNext() {
            if (i < items.length) {
                itemStore.put(items[i]).onsuccess = putNext;
                ++i;
            } else {   // complete
                console.log('populate complete');
                callback(db, null);
            }
        }
    }


    /**
     * Fetch all of the todo items in the datastore.
     * @param {function} callback A function that will be executed once the items
     *                            have been retrieved. Will be passed a param with
     *                            an array of the todo items.
     */
    iDB.fetchTodos = function (callback) {
        var db = datastore;
        var transaction = db.transaction(['todo'], 'readwrite');
        var objStore = transaction.objectStore('todo');

        var keyRange = IDBKeyRange.lowerBound(0);
        var cursorRequest = objStore.openCursor(keyRange);

        var todos = [];

        transaction.oncomplete = function (e) {
            // Execute the callback function.
            callback(todos);
        };

        cursorRequest.onsuccess = function (e) {
            var result = e.target.result;

            if (!!result == false) {
                return;
            }

            todos.push(result.value);

            result.continue();
        };

        cursorRequest.onerror = tDB.onerror;
    };


    /**
     * Create a new todo item.
     * @param {string} text The todo item.
     */
    iDB.createTodo = function (text, callback) {
        // Get a reference to the db.
        var db = datastore;

        // Initiate a new transaction.
        var transaction = db.transaction(['todo'], 'readwrite');

        // Get the datastore.
        var objStore = transaction.objectStore('todo');

        // Create a timestamp for the todo item.
        var timestamp = new Date().getTime();

        // Create an object for the todo item.
        var todo = {
            'text': text,
            'timestamp': timestamp
        };

        // Create the datastore request.
        var request = objStore.put(todo);

        // Handle a successful datastore put.
        request.onsuccess = function (e) {
            // Execute the callback function.
            callback(todo);
        };

        // Handle errors.
        request.onerror = tDB.onerror;
    };


    /**
     * Delete a todo item.
     * @param {int} id The timestamp (id) of the todo item to be deleted.
     * @param {function} callback A callback function that will be executed if the 
     *                            delete is successful.
     */
    iDB.deleteTodo = function (id, callback) {
        var db = datastore;
        var transaction = db.transaction(['todo'], 'readwrite');
        var objStore = transaction.objectStore('todo');

        var request = objStore.delete(id);

        request.onsuccess = function (e) {
            callback();
        }

        request.onerror = function (e) {
            console.log(e);
        }
    };


    // Export the tDB object.
    return iDB;
}());
