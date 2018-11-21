
"use strict";

var myApp = angular.module('myApp', ['ui.bootstrap', 'ui.router']);

myApp.config(['$urlRouterProvider', '$stateProvider', '$locationProvider',
  function ($urlRouterProvider, $stateProvider, $locationProvider) {

      $locationProvider.html5Mode(true);

      $stateProvider
        .state('reposicionCajaChica', {
            url: '/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica',
            templateUrl: 'reposicionCajaChica.html',
            controller: 'ReposicionCajaChicaController'
        })
        .state('reposicionCajaChica.filtro', {
            templateUrl: 'reposicionCajaChica.filtro.html',
            parent: 'reposicionCajaChica'
        })
        .state('reposicionCajaChica.lista', {
            templateUrl: 'reposicionCajaChica.lista.html',
            parent: 'reposicionCajaChica'
        })
        .state('reposicionCajaChica.entidad', {
            templateUrl: 'reposicionCajaChica.entidad.html',
            parent: 'reposicionCajaChica'
        });

      $urlRouterProvider.otherwise('/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica');
  }]);


myApp.controller("CajaChicasReposicionesController", function ($scope, $stateParams, $state) {
});

myApp.controller("ReposicionCajaChicaController", function ($scope, $stateParams, $state, DataBaseFunctions) {

    $scope.showProgress = false;

    $scope.companias = [];
    $scope.rubrosCajaChica = [];
    $scope.cajasChicas = [];
    $scope.usuarios = [];

    // -----------------------------------------------------------------
    // inicialización de LokiDB

    //var lk_idbAdapter = new lokiIndexedAdapter('finanzas');

    var lkColl_companias = null;
    var lkColl_rubrosCajaChica = null;
    var lkColl_cajasChicas = null;
    var lkColl_usuarios = null;
 
    var lokiDB = new loki('dbContab',
      {
          autoload: true,
          autoloadCallback: lokiLoadHandler,
          autosave: true,
          autosaveInterval: 10000
          //adapter: lk_idbAdapter
      });

    function lokiLoadHandler() {
        
        // if database did not exist it will be empty so I will intitialize here
       lkColl_companias = lokiDB.getCollection('companias');
        if (lkColl_companias === null) {
            lokiDB.addCollection('companias');
        };

        lkColl_rubrosCajaChica = lokiDB.getCollection('rubrosCajaChica');
        if (lkColl_companias === null) {
            lokiDB.addCollection('rubrosCajaChica');
        };

        lkColl_cajasChicas = lokiDB.getCollection('cajasChicas');
        if (lkColl_cajasChicas === null) {
            lokiDB.addCollection('cajasChicas');
        };

        lkColl_usuarios = lokiDB.getCollection('usuarios');
        if (lkColl_usuarios === null) {
            lokiDB.addCollection('usuarios');
        };

        // aprovechamos para cargar los catálogos en el $scope 

        var companias = lkColl_companias.chain().find({}).simplesort('nombre').data();
        var rubrosCajaChica = lkColl_rubrosCajaChica.chain().find({}).simplesort('nombre').data();
        var cajasChicas = lkColl_cajasChicas.chain().find({}).simplesort('nombre').data();
        var usuarios = lkColl_usuarios.chain().find({}).simplesort('nombre').data();

        companias.forEach(function (item) {
            $scope.companias.push(item);
        });

        rubrosCajaChica.forEach(function (item) {
            $scope.rubrosCajaChica.push(item);
        });

        cajasChicas.forEach(function (item) {
            $scope.cajasChicas.push(item);
        });

        usuarios.forEach(function (item) {
            $scope.usuarios.push(item);
        });
    };
    // -----------------------------------------------------------------

  
    // ui-bootstrap alerts ...
    $scope.alerts = [];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

    $scope.ciaContabSeleccionada = {};

    // leemos la cia contab seleccionada al abrir la página y mostramos un error si no hay una 

    function leerCiaContabSeleccionada() {

        $scope.showProgress = true;

        DataBaseFunctions.leerCiaContabSeleccionada().then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                if (!DataBaseFunctions.ciaContabSeleccionada || !DataBaseFunctions.ciaContabSeleccionada.numero) {
                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "No hay una compañía (Contab) seleccionada. Debe seleccionar una compañía antes de iniciar este proceso."
                    });

                    $scope.showProgress = false;
                    return;
                }

                $scope.ciaContabSeleccionada.numero = DataBaseFunctions.ciaContabSeleccionada.numero;
                $scope.ciaContabSeleccionada.nombre = DataBaseFunctions.ciaContabSeleccionada.nombre;
            },
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            });
    };


    $scope.leerCatalogosDesdeServidor = function () {

        if (!$scope.ciaContabSeleccionada || !$scope.ciaContabSeleccionada.numero) {
            $scope.alerts.push({
                type: 'danger',
                msg: "No se ha seleccionado una compañía aún. Ud. debe seleccionar una compañía <b>antes</b> de intentar ejecutar este proceso."
            });

            return;
        };

        $scope.showProgress = true;

        DataBaseFunctions.leerCatalogosDesdeServidor().then(

            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };


                // refrescamos el contenido de los collections en loki, con el contenido de las tablas leídas desde el servidor 

                // primero eliminamos el contenido que pueda existir en los collections (loki) 

                lkColl_companias.removeWhere(function (obj) { return true; });
                lkColl_rubrosCajaChica.removeWhere(function (obj) { return true; });
                lkColl_cajasChicas.removeWhere(function (obj) { return true; });
                lkColl_usuarios.removeWhere(function (obj) { return true; });

                // Ok, ahora cargamos el contenido nuevamente 

                DataBaseFunctions.companias.forEach(function (item) {
                    lkColl_companias.insert(item); 
                });

                DataBaseFunctions.rubrosCajaChica.forEach(function (item) {
                    lkColl_rubrosCajaChica.insert(item);
                });

                DataBaseFunctions.cajasChicas.forEach(function (item) {
                    lkColl_cajasChicas.insert(item);
                });

                DataBaseFunctions.usuarios.forEach(function (item) {
                    lkColl_usuarios.insert({ nombre: item });
                });

                lokiDB.save();

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: "Ok, los catálogos han sido cargados desde el servidor."
                });

                $scope.showProgress = false;
                  
            },
            function (err) {

                debugger;

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            });

    };

   
    leerCiaContabSeleccionada();


    $scope.aplicarFiltro = function () {

        debugger; 

        $scope.showProgress = true;

        DataBaseFunctions.aplicarFiltro("todas", true, $scope.ciaContabSeleccionada.numero).then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.resultMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                

                $state.go('reposicionCajaChica.lista', {});
            },
            function (err) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;
            });
    };

    $scope.nuevo = function () {
        $state.go('reposicionCajaChica.entidad', {});
    };

    $scope.regresarLista = function () {
        $state.go('reposicionCajaChica.lista', {});
    };

    $scope.regresarFiltro = function () {
        $state.go('reposicionCajaChica.filtro', {});
    };

    // inicialmente, siempre abrimos el state 'filter' ... 
    $state.go('reposicionCajaChica.filtro', {});

}); 

myApp.factory("DataBaseFunctions", function ($http, $q) {

    var factory = {};

    factory.ciaContabSeleccionada = {};

    factory.companias = [];
    factory.rubrosCajaChica = [];
    factory.cajasChicas = [];
    factory.usuarios = [];

    factory.leerCiaContabSeleccionada = function () {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'CajaChica')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/LeerCiaContabSeleccionada";

        var deferred = $q.defer();

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.ciaContabSeleccionada.numero = result.ciaContabSeleccionada;
                factory.ciaContabSeleccionada.nombre = result.ciaContabSeleccionadaNombre;

                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri
                });
            });

        return deferred.promise;
    };

    factory.leerCatalogosDesdeServidor = function () {

        // leemos los datos iniciales de la página desde el servidor ...
        // path contiene el uri de la aplicación (ej: http://localhost:15590); el código que lo inicializa está en _Layout.cshtml

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/LeerCatalogos?ciaContabSeleccionada=" + factory.ciaContabSeleccionada.numero;

        var deferred = $q.defer();

        $http.get(uri).then(
            function (result) {

                // leemos cada uno de los archivos recibidos y los cargamos en variables del factory 

                factory.companias.length = 0; 
                factory.rubrosCajaChica.length = 0;
                factory.cajasChicas.length = 0;
                factory.usuarios.length = 0;

                result.data.proveedores.forEach(function (item) {
                    factory.companias.push(item); 
                });

                result.data.rubrosCajaChica.forEach(function (item) {
                    factory.rubrosCajaChica.push(item);
                });

                result.data.usuarios.forEach(function (item) {
                    factory.usuarios.push(item);
                });

                result.data.cajasChicas.forEach(function (item) {
                    factory.cajasChicas.push(item);
                });

                deferred.resolve(result);

            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri
                });
            });

        return deferred.promise;
    }; 

    factory.aplicarFiltro = function (tipoReposiciones, cualquierUsuario, ciaContab) {

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'CajaChica')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/RelacionMontosAPagarWebApi/AplicarFiltro";

        var deferred = $q.defer();

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({
                    number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri
                });
            });

        return deferred.promise;

    }; 

    return factory;
});



// ---------------------------------------------------------------------------------------
// para mostrar 'unsafe' strings (with embedded html) in ui-bootstrap alerts ....
// ---------------------------------------------------------------------------------------
myApp.filter('unsafe', function ($sce) {
    return function (value) {
        if (!value) { return ''; }
        return $sce.trustAsHtml(value);
    };
});
































//var dbobject;            // base de datos (IndexedDB) 

var Reposicion_PageItem = function (item) {

    var self = this;

    self.id = item.id; 

    self.reposicionID = ko.observable(item.reposicionID);
    self.fecha = ko.observable(item.fecha);
    self.estado = ko.observable(item.estado);

    // el nombre de la caja chica lo buscamos en el array de cajas chicas en el viewModel 
    var cajaChica = _.find(viewModel.cajasChicasJson, function (value) {
        return value.id = item.cajaChicaID; 
    });

    if (cajaChica)
        self.nombreCajaChica = ko.observable(cajaChica.descripcion);
    else
        self.nombreCajaChica = ko.observable("indefinido ...");

    // calculamos los totales en el 'sub' array de gastos 

    var lineas = item.gastos.length;
    var montoNoImponible = _.reduce(item.gastos, function (memo, num) { return memo + num.montoNoImponible; }, 0);
    var montoImponible = _.reduce(item.gastos, function (memo, num) { return memo + num.montoImponible; }, 0);
    var iva = _.reduce(item.gastos, function (memo, num) { return memo + num.iva; }, 0);
    var total = _.reduce(item.gastos, function (memo, num) { return memo + num.total; }, 0);
    
    self.cantLineas = ko.observable(lineas);
    self.totalMontoNoImponible = ko.observable(montoNoImponible);
    self.totalMontoImponible = ko.observable(montoImponible);
    self.totalIva = ko.observable(iva);
    self.totalReposicion = ko.observable(total);
}

var ReposicionJson = function (item) {

    var self = this;

    self.id = item.Id;

    self.reposicionID = item.ReposicionID; 
    self.fecha = item.Fecha;
    self.cajaChicaID = item.CajaChicaID;
    self.observaciones = item.Observaciones;
    self.estado = item.Estado;
    self.ciaContabID = item.CiaContabID;
    self.usuario = item.Usuario;

    self.gastos = new Array(); 

    item.Gastos.forEach(function (value) {
        self.gastos.push(new GastoJson(value)); 
    }); 
}

var GastoJson = function (item) {

    this.rubroID = item.RubroID; 
    this.descripcion = item.Descripcion;
    this.fechaDoc = item.FechaDoc;
    this.numeroDoc = item.NumeroDoc;
    this.numeroControl = item.NumeroControl;
    this.proveedorID = item.ProveedorID;
    this.proveedor2 = item.Proveedor2;
    this.rif = item.Rif;
    this.montoNoImponible = item.MontoNoImponible;
    this.montoImponible = item.MontoImponible;
    this.ivaPorc = item.IvaPorc;
    this.iva = item.Iva;
    this.total = item.Total;
    this.afectaLibroCompras = item.AfectaLibroCompras;

}

var Gasto = function (item, array) {

    var self = this;
    self.parentArray = array; 

    self.rubroID = ko.observable(item ? item.rubroID : null),
    self.descripcion = ko.observable(item ? item.descripcion : null),
    self.fechaDoc = ko.observable(item ? moment(item.fechaDoc).format("DD-MM-YY") : moment().format("DD-MM-YY")),
    self.numeroDoc = ko.observable(item ? item.numeroDoc : null),
    self.numeroControl = ko.observable(item ? item.numeroControl : null),
    self.proveedorID = ko.observable(item ? item.proveedorID : null),
    self.proveedor2 = ko.observable(item ? item.proveedor2 : null),
    self.rif = ko.observable(item ? item.rif : null),
    self.montoNoImponible = ko.observable(item ? item.montoNoImponible : new Number()),
    self.montoImponible = ko.observable(item ? item.montoImponible : new Number()),
    self.ivaPorc = ko.observable(item ? item.ivaPorc : null),

    //self.iva = ko.observable(item ? item.iva : new Number()),
    //self.total = ko.observable(item ? item.total : new Number()),

    self.afectaLibroCompras = ko.observable(item ? item.afectaLibroCompras : false)

    // computeds

    self.iva = ko.computed(function () {
        var iva = 0;
        if (!isNaN(parseFloat(this.montoImponible())) && !isNaN(parseFloat(this.ivaPorc())))
            var iva = parseFloat(this.montoImponible()) * parseFloat(this.ivaPorc()) / 100;
        this.parentArray.valueHasMutated();
        return iva;
    }, self);

    self.total = ko.computed(function () {
        var montoNoImponible = isNaN(parseFloat(this.montoNoImponible())) ? 0 : parseFloat(this.montoNoImponible());
        var montoImponible = isNaN(parseFloat(this.montoImponible())) ? 0 : parseFloat(this.montoImponible());
        var iva = isNaN(parseFloat(this.iva())) ? 0 : parseFloat(this.iva());

        self.parentArray.valueHasMutated();
        return montoNoImponible + montoImponible + iva;
    }, self);
}

var Reposicion = function () {

    // para crear un item, con observables ... 

    var self = this;

    self.id = null;

    self.reposicionID = ko.observable(null);
    self.fecha = ko.observable(null);

    self.cajaChicaID = ko.observable(null);
    self.observaciones = ko.observable(new String());
    self.estado = ko.observable(new String());
    self.ciaContabID = null;
    self.usuario = null;

    self.gastos = ko.observableArray();

    // definimos los computeds ... 

    self.cantidadLineas = ko.computed(function () {
        return this.gastos().length;
    }, self);


    self.totalMontoNoImponible = ko.computed(function () {
        var total = 0;
        ko.utils.arrayForEach(this.gastos(), function (item) {
            var value = isNaN(parseFloat(item.montoNoImponible())) ? 0 : parseFloat(item.montoNoImponible());
            total += value;
        });
        return total;
    }, self);

    self.totalMontoImponible = ko.computed(function () {
        var total = 0;
        ko.utils.arrayForEach(this.gastos(), function (item) {
            var value = isNaN(parseFloat(item.montoImponible())) ? 0 : parseFloat(item.montoImponible());
            total += value;
        });
        return total;
    }, self);

    self.totalMontoIva = ko.computed(function () {
        var total = 0;
        ko.utils.arrayForEach(this.gastos(), function (item) {
            var value = isNaN(parseFloat(item.iva())) ? 0 : parseFloat(item.iva());
            total += value;
        });
        return total;
    }, self);

    self.totalMontoTotal = ko.computed(function () {
        var total = 0;
        ko.utils.arrayForEach(this.gastos(), function (item) {
            var value = isNaN(parseFloat(item.total())) ? 0 : parseFloat(item.total());
            total += value;
        });
        return total;
    }, self);

}

function initItem(item, initFromValues) {

    // para inicializar este item que usamos para mostrar un item al usuario; 
    // nótese que, para agregar, simplemente pasamos null 

    if (!initFromValues)
    {
        // el usuario va a agregar un registro 

        item.id = null; 
        item.reposicionID(0);
        item.fecha(moment(new Date()).format("DD-MM-YY"));
        item.cajaChicaID(null);
        item.observaciones(new String());
        item.estado("AB");
        item.ciaContabID = viewModel.ciaContabSeleccionada;
        item.usuario = viewModel.usuario;
    }
    else
    {
        // el usuario quiere actualizar un item 

        item.id = initFromValues.id;
        item.reposicionID(initFromValues.reposicionID);
        item.fecha(moment(initFromValues.fecha).format("DD-MM-YY"));
        item.cajaChicaID(initFromValues.cajaChicaID);
        item.observaciones(initFromValues.observaciones);
        item.estado(initFromValues.estado);
        item.ciaContabID = initFromValues.ciaContabID;
        item.usuario = initFromValues.usuario;
    }

    if (!initFromValues)
    {
        // el usuario va a agregar un registro 
        item.gastos.removeAll();
        item.gastos.push(new Gasto(null, item.gastos)); 
    }
    else
    {
        // el usuario quiere actualizar un item 
        item.gastos.removeAll();

        initFromValues.gastos.forEach(function (value) {
            item.gastos.push(new Gasto(value, item.gastos)); 
        }); 
    }
}


var ViewModel = function () {

    var self = this;

    self.ciaContabSeleccionada = new Number();
    self.ciaContabSeleccionadaNombre = ko.observable();
    self.usuario = new String();

    self.companias = ko.observableArray();
    self.rubrosCajaChica = ko.observableArray();
    self.cajasChicas = ko.observableArray();
    self.cajasChicasJson = new Array();
    self.usuarios = ko.observableArray();

    self.usuarioEmail = ko.observable();

    self.filtro = {
        estadoReposiciones: ko.observable("todas"),              // todas / abiertas / cerradas 
        cualquierUsuario: ko.observable(false)                       // propio / todos 
    };

    self.reposiciones = new Array();

    self.reposicion = new Reposicion();
    self.reposicion.gastos.push(new Gasto(null, self.reposicion.gastos));

    self.gastosCajaChica_agregar = function () {
        // agregamos un linea para un nuevo gasto 
        self.reposicion.gastos.push(new Gasto(null, self.reposicion.gastos)); 
    };

    self.gastosCajaChica_eliminar = function (item) {
        // eliminamos un gasto de la lista ... 
        self.reposicion.gastos.remove(item); 
    };

    self.pageData = {
        pageSize: ko.observable(10),
        numberOfPages: ko.observable(0),
        maxVisiblePages: ko.observable(0),

        itemsPage: ko.observableArray(),
    };

    self.idItemToDelete = new String();             // para registrar el id del item a eliminar y que esté disponible si el usuario confirma el diálogo 

    self.cerrarReposicion = function (vm) {
        cerrarReposicionAlServidor(vm.reposicion); 
    }

    self.notificarViaEmail = function () {
        $("#notificarViaEmailModal").dialog("open");
    }

    self.tableRowFocus = function () {
        var a = "hello!!"; 
    }
};

var viewModel = new ViewModel(); 
ko.applyBindings(viewModel);


// -----------------------------------------------------------------------------
// para leer la compañía seleccionada al abrirse la página ... 
// -----------------------------------------------------------------------------

//(function () {

//    // leemos los datos iniciales de la página desde el servidor ...
//    // path contiene el uri de la aplicación (ej: http://localhost:15590); el código que lo inicializa está en _Layout.cshtml

//    // nótese como obtenemos el (base) uri de la página ... 
//    var location = window.location.protocol + "//" + window.location.host + "/";
//    var pathArray = window.location.pathname.split('/');
//    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
//        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
//        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
//        location += pathArray[1] + '/';

//    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/LeerCiaContabSeleccionada";

//    $.getJSON(uri)
//        .done(function (result) {

//            $(".mensajeAlUsuario").html("");

//            if (result.ErrorFlag) {
//                $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
//                return false;
//            }

//            viewModel.ciaContabSeleccionada = result.ciaContabSeleccionada;
//            viewModel.ciaContabSeleccionadaNombre(result.ciaContabSeleccionadaNombre);
//            viewModel.usuario = result.nombreUsuario; 

//            // abrimos la base de datos (local mongo) e intentamos cargar los arrays (observable) en el viewModel 
//            //abrirMongoYCargarCatalogosEnViewModel(); 
//        })
//        .fail(function (jqxhr, textStatus, error) {
//            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
//            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
//            $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);
//        });
//})();





// -------------------------------------------------------------------
// especie de dialog box para mostrar un mensaje al usuario, cada vez que 
// un proceso se completa ... 

$("#mensajeAlUsuarioDialog").dialog({
    autoOpen: false,
    width: 450,
    modal: true,
    buttons: [
        {
            text: "Ok",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});


$("#mensajeEliminarItem_Dialog").dialog({
    autoOpen: false,
    width: 450,
    modal: true,
    buttons: [
        {
            text: "Ok",
            click: function () {
                deleteItemFromList();
            }
        },
        {
            text: "Cancelar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});


// --------------------------------------------------------------------------------------------------
// para leer los catálogos desde el servidor y cargarlos en local storage (IndexedDB) 

function refreshCatalogos() {

    if (!viewModel.ciaContabSeleccionada) 
    {
        var errMessage = "Aparentemente, no se ha seleccionado una compañía aún; por favor seleccione una compañía (Contab) y regrese a ejecutar este proceso.";
        $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);

        $("#mensajeAlUsuarioDialog").dialog("open"); 
    }

    // leemos los datos iniciales de la página desde el servidor ...
    // path contiene el uri de la aplicación (ej: http://localhost:15590); el código que lo inicializa está en _Layout.cshtml

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/LeerCatalogos?ciaContabSeleccionada=" + viewModel.ciaContabSeleccionada;

    $.getJSON(uri)
        .done(function (result) {

            $(".mensajeAlUsuario").html("");

            if (result.ErrorFlag) {
                $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
                return false;
            }

            // actualizamos los arrays en viewModel con cada catálogo recibido desde el servidor; luego, estos mismos datos 
            // serán leídos para actualizar las tablas en mongo (local) 

            // nótese como usamos mongo para cargar los arrays (non persistent mongo) y, en este caso, ordenar por alguno de los fields ... 
            // en general, podemos usar mongo para cargar algunos arrays y luego manipularlos con el api de mongo ... 

            // TODO: mejor hacer ésto en underscore.js (???) 

            viewModel.companias.removeAll();
            viewModel.rubrosCajaChica.removeAll();
            viewModel.cajasChicas.removeAll();
            viewModel.usuarios.removeAll(); 

            viewModel.cajasChicasJson.length = 0;

            var companiasMongo = new Nedb({ inMemoryOnly: true, autoload: true });
            var rubrosCajaChiaMongo = new Nedb({ inMemoryOnly: true, autoload: true });
            var cajasChicasMongo = new Nedb({ inMemoryOnly: true, autoload: true });
            var usuariosMongo = new Nedb({ inMemoryOnly: true, autoload: true });

            companiasMongo.insert(result.proveedores, function (err) {
                companiasMongo.find({}).sort({ abreviatura: 1 }).exec(function (err, docs) {
                    docs.forEach(function (item) {
                        // nótese cómo usamos el id original de cada item en el array; como no lo indicamos en mongo, éste agregó su propio _id 
                        // al hacer el 'bulk-insert' ... 
                        viewModel.companias.push({ id: item.Id, nombre: item.nombre, abreviatura: item.abreviatura });
                    })
                });
            });

            rubrosCajaChiaMongo.insert(result.rubrosCajaChica, function (err) {
                rubrosCajaChiaMongo.find({}).sort({ descripcion: 1 }).exec(function (err, docs) {
                    docs.forEach(function (item) {
                        viewModel.rubrosCajaChica.push({ id: item.Id, descripcion: item.descripcion, abreviatura: item.abreviatura });
                    })
                });
            });

            cajasChicasMongo.insert(result.cajasChicas, function (err) {
                cajasChicasMongo.find({ ciaContab: viewModel.ciaContabSeleccionada }).sort({ descripcion: 1 }).exec(function (err, docs) {
                    docs.forEach(function (item) {
                        viewModel.cajasChicas.push({ id: item.Id, descripcion: item.descripcion });         // ko 
                        viewModel.cajasChicasJson.push({ id: item.Id, descripcion: item.descripcion });     // json 
                    })
                });
            });

            // usamos lo-dash para ordenar ... 
            _.sortBy(result.usuarios).forEach(function (value) {
                viewModel.usuarios.push(value);
            });

            actualizarCatalogosEnLocalMongo(result.proveedores, result.rubrosCajaChica, result.cajasChicas, result.usuarios); 
        })
        .fail(function (jqxhr, textStatus, error) {
            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
            $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);
        });
}


// para aplicar el filtro que indique el usuario ... 

// -------------------------------------------------------------------
// especie de dialog box para mostrar un mensaje al usuario, cada vez que 
// un proceso se completa ... 

$("#filtroModal").dialog({
    autoOpen: false,
    width: 650,
    modal: true,
    buttons: [
        {
            text: "Ok",
            click: function () {
                aplicarFiltro();
            }
        },
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});


function aplicarFiltroAbrirModal() {
    $("#filtroModal").dialog("open"); 
}

function aplicarFiltro() {

    if (!viewModel.ciaContabSeleccionada) {
        var errMessage = "Aparentemente, no se ha seleccionado una compañía aún; por favor seleccione una compañía (Contab) y regrese a ejecutar este proceso.";
        $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);

        $("#mensajeAlUsuarioDialog").dialog("open");
    }


    // leemos los datos iniciales de la página desde el servidor ...
    // path contiene el uri de la aplicación (ej: http://localhost:15590); el código que lo inicializa está en _Layout.cshtml

    var filtro = "reposiciones=" + viewModel.filtro.estadoReposiciones() +
                 "&cualquierUsuario=" + viewModel.filtro.cualquierUsuario().toString() +
                 "&ciaContab=" + viewModel.ciaContabSeleccionada.toString();

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/AplicarFiltro?" + filtro;

    $.getJSON(uri)
        .done(function (result) {

            $(".mensajeAlUsuario").html("");

            if (result.ErrorFlag) {
                $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
                $("#filtroModal").dialog("close");
                return false;
            }

            // nótese como lo que sigue es como: !string.isnullorempty ...
            if (result.ResultMessage) {
                $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
            }

            // agregamos los items recibidos desde el servidor, al viewModel 

            viewModel.reposiciones.length = 0;

            // nótese como ordenamos la lista de reposiciones obtenida desde el servidor ... 
            _.sortBy(result.listaReposiciones, 'Fecha', 'ReposicionID').forEach(function (value) {
                viewModel.reposiciones.push(new ReposicionJson(value));
            }); 

            // ------------------------------------------------------------------------------------------------------------------------------
            // nótese como inicializamos el (bootstrap) pager 

            viewModel.pageData.numberOfPages(0);
            viewModel.pageData.maxVisiblePages(8);              // el default, para nosotros, es 8; será menor si no hay tantas páginas ... 

            var cantidadPaginas = 0;

            if (viewModel.reposiciones.length > 0) {
                var cantidadPaginas = (viewModel.reposiciones.length % viewModel.pageData.pageSize() === 0) ?
                                      (viewModel.reposiciones.length / viewModel.pageData.pageSize()) :
                                      ((Math.floor(viewModel.reposiciones.length / viewModel.pageData.pageSize())) + 1);

                viewModel.pageData.numberOfPages(cantidadPaginas);

                if (cantidadPaginas < 8)
                    viewModel.pageData.maxVisiblePages(cantidadPaginas);
            }

            $("#page-selection").bootpag({ total: cantidadPaginas, maxVisible: viewModel.pageData.maxVisiblePages(), page: 1 });
            // ------------------------------------------------------------------------------------------------------------------------------

            // para leer la primera página del array 
            buildPageList(viewModel.pageData.pageSize(), 1, viewModel.reposiciones, viewModel.pageData.itemsPage);

            $("#filtroModal").dialog("close");
        })
        .fail(function (jqxhr, textStatus, error) {
            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
            $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);

            $("#filtroModal").dialog("close");
        });
}

// para agregar un nuevo registro 

$("#nuevoRegistroModal").dialog({
    autoOpen: false,
    width: 1250,
    modal: true,
    buttons: [
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});

function agregarNuevoRegistro() {
    
    // cómo el usuario va a agregar un registro, inicializamos en nulls el 'buffer' que pasamos a la forma ... 

    initItem(viewModel.reposicion, null); 
    $("#nuevoRegistroModal").dialog("open"); 
}

// para enviar el item que el usuario ha editado al servidor, para registrarlo en mongo 

function grabarItemAlServidor() {

    var jsonDataAsString = ko.toJS(viewModel.reposicion);

    // nótese como eliminamos una propiedad en el objeto, que hace referencia al 'array original', en un item del propio array; es un recurso que usamos en ko, 
    // para que un computed en un item en el array notique al array (propiamente) 
    jsonDataAsString.gastos.forEach(function (item) {
        delete item.parentArray; 
    });

    jsonDataAsString = JSON.stringify(jsonDataAsString, JsonReplacer);

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/GrabarItemsAMongo";

    $.ajax({
        type: "POST",
        data: { '': jsonDataAsString },     // nótese que pasamos un objeto, para que el web api method lo pueda recibir como un value type (string) y no como json (type)
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done( function(result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            $("#mensajeAlUsuarioDialog").dialog("open");
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");

        // finalmente, actualizamos la clave (_id) del registro; si el usuario acaba de agregar un registro, 
        // debemos actualizar su clave, por si acaso decide modificarlo de inmediato ... 

        viewModel.reposicion.id = result.ItemID;
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".MensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    });
}

// para cambiar el formato de las fechas cuando serializamos el objeto que vamos a pasar al servidor 
function JsonReplacer(key, value) {
    if (key == "fecha" || key == "fechaDoc")
        return moment(value, "DD-MM-YY").format("YYYY-MM-DD"); 
    else 
        return value; 
};


function editarReposicion(item) {

    // buscamos el item específico que el usuario seleccionó en la lista y lo pasamos a la función, 
    // para inicializar el 'buffer' que el usuario debe editar en la forma 
    var itemToEdit = _.find(viewModel.reposiciones, function (value) {
        return value.id === item.id;
    });

    initItem(viewModel.reposicion, itemToEdit);
    $("#nuevoRegistroModal").dialog("open");
}



// para 'preparar' una página de items para mostrarla en la forma 

function buildPageList(pageSize, pageNumber, sourceArray, targetArray) {

    // NOTA: esta función espera que el número de la página comience en 1 (no en 0) 

    targetArray.removeAll();         // nótese que el target array es en realidad un ko.observableArray 

    //$.each(result.Facturas, function (index, item) {
    //    viewModel.facturas.push(new Factura(item));
    //});

    var from = ((pageNumber - 1) * pageSize);
    var to = (pageNumber * pageSize);

    for (var i = from; i < to; i++) {
        if (i > (sourceArray.length - 1)) {
            to = i;
            break;
        }

        // agregamos un item a la página 
        targetArray.push(new Reposicion_PageItem(sourceArray[i]));
    }

    //viewModel.pageData.currentPage(pageNumber);
    //viewModel.pageData.currentPageFrom(from + 1);
    //viewModel.pageData.currentPageTo(to);
};

$('#page-selection').bootpag({
    total: 0,
    page: 1,
    maxVisible: 1
}).on('page', function (event, num) {
    // nótese que el (bootstrap) pager regresa la página basada en 1 (y no en 0) 
    buildPageList(viewModel.pageData.pageSize(), num, viewModel.reposiciones, viewModel.pageData.itemsPage);
});

// para eliminar el registro que el usuario indique en la lista 

function deleteItemFromList_Confirmar(item) {
    viewModel.idItemToDelete = item.id; 
    $("#mensajeEliminarItem_Dialog").dialog("open"); 
}

function deleteItemFromList() {
    var id = viewModel.idItemToDelete;
    $("#mensajeEliminarItem_Dialog").dialog("close");

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/DeleteReposicion?itemID=" + id;

    $.ajax({
        type: "POST",
        //data: { '': jsonDataAsString },     // nótese que pasamos un objeto, para que el web api method lo pueda recibir como un value type (string) y no como json (type)
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done(function (result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".MensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });
}


// cerramos una reposición y la pasamos a Contab ... 

function cerrarReposicionAlServidor(reposicion)
{
    var jsonDataAsString = ko.toJS(reposicion);

    // nótese como eliminamos una propiedad en el objeto, que hace referencia al 'array original', en un item del propio array; es un recurso que usamos en ko, 
    // para que un computed en un item en el array notique al array (propiamente) 
    jsonDataAsString.gastos.forEach(function (item) {
        delete item.parentArray;
    });

    jsonDataAsString = JSON.stringify(jsonDataAsString, JsonReplacer);  // jsonReplacer cambia el formato de fechas, desde d-m-y a y-m-d 

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/CerrarReposicionYPasarAContab/1";

    $.ajax({
        type: "POST",
        data: { '': jsonDataAsString },     // nótese que pasamos un objeto, para que el web api method lo pueda recibir como un value type (string) y no como json (type)
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done(function (result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            $("#mensajeAlUsuarioDialog").dialog("open");
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        // actualizamos el número de la reposición y su estado en la página, para que el usuario pueda 
        // ver su reposición actualizada ... 

        viewModel.reposicion.reposicionID(result.ItemID);
        viewModel.reposicion.estado("CE"); 

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".MensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    });
}


$("#notificarViaEmailModal").dialog({
    autoOpen: false,
    width: 600,
    modal: true,
    buttons: [
        {
            text: "Enviar e-mail",
            click: function () {
                notificarReposicionViaEmail(viewModel.reposicion.id, viewModel.usuarioEmail())
            }
        }, 
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});


// permitimos enviar un e-mail, para notificar el registro de la reposición en Contab

function notificarReposicionViaEmail(reposicionID, usuarioEmail) {

    // la reposición debe estar cerrada y tener un número (cualquier reposición ya cerrada *debe* tener un número) ... 

    var reposicionEstado = viewModel.reposicion.estado();
    var reposicionNumero = viewModel.reposicion.reposicionID();

    if (reposicionEstado != "CE" || !reposicionNumero === 0)
    {
        var message = "Solo reposiciones <em>cerradas</em> y con un número de reposición en Contab, pueden ser notificadas.<br />" + 
                      "Ud. debe cerrar la reposición antes de intentar notificarla."; 
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(message);

        $("#notificarViaEmailModal").dialog("close");
        $("#mensajeAlUsuarioDialog").dialog("open");

        return false; 
    }


    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';

    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/NotificarReposicionViaEmail?repID=" + reposicionID + "&usuarioEmail=" + usuarioEmail;

    $.getJSON(uri)
        .done(function (result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            $("#mensajeAlUsuarioDialog").dialog("open");
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        $("#notificarViaEmailModal").dialog("close"); 

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".MensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    });
}


// -----------------------------------------
// mostramos la reposición en formato Excel 

$("#downloadExcelFile").dialog({
    autoOpen: false,
    width: 600,
    modal: true,
    buttons: [
        {
            text: "Cerrar",
            click: function () {
                $(this).dialog("close");
            }
        }
    ]
});

function exportarAExcel() {

    var id = viewModel.reposicion.id;

    // nótese como obtenemos el (base) uri de la página ... 
    var location = window.location.protocol + "//" + window.location.host + "/";
    var pathArray = window.location.pathname.split('/');
    if (pathArray[1] && pathArray[1] != 'CajaChica')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
        // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
        // cuando desarrollamos, no existe (ej: http://localhost:5050) 
        location += pathArray[1] + '/';
   
    var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/ExportarAExcel?itemID=" + id;

    $.ajax({
        type: "GET",
        //data: { '': jsonDataAsString },     // nótese que pasamos un objeto, para que el web api method lo pueda recibir como un value type (string) y no como json (type)
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done(function (result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            $("#mensajeAlUsuarioDialog").dialog("open"); 
            return false;
        }

        // abrimos un jquery modal que permite al usuario descargar (download) el documento Excel 

        $("#downloadExcelFile").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".MensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });

}