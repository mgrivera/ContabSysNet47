
"use strict";

var myApp = angular.module('myApp', ['ui.bootstrap', 'ui.router', 'ui.grid', 'ui.grid.edit', 'ui.grid.cellNav', 'ui.grid.resizeColumns', 'ui.grid.selection']);

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
            url: '/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica/filtro',
            templateUrl: 'reposicionCajaChica.filtro.html',
            parent: 'reposicionCajaChica'
        })
        .state('reposicionCajaChica.lista', {
            url: '/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica/lista',
            templateUrl: 'reposicionCajaChica.lista.html',
            parent: 'reposicionCajaChica'
        })
        .state('reposicionCajaChica.entidad', {
            url: '/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica/entidad',
            templateUrl: 'reposicionCajaChica.entidad.html',
            parent: 'reposicionCajaChica'
        });

      $urlRouterProvider.otherwise('/CajaChica/ReposicionesCajaChica/Index/reposicionCajaChica');
  }]);


myApp.controller("CajaChicasReposicionesController", function ($scope) {
});

myApp.controller("ReposicionCajaChicaController", function ($scope, $stateParams, $state, DataBaseFunctions, $modal, uiGridConstants) {

    $scope.showProgress = false;

    $scope.companias = [];
    $scope.rubrosCajaChica = [];
    $scope.cajasChicas = [];
    $scope.usuarios = [];

    $scope.reposicionCajaChica = {}; 

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

                $scope.showProgress = false;
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

        $scope.showProgress = true;

        var filtro = { Cia: $scope.ciaContabSeleccionada.numero }; 

        DataBaseFunctions.aplicarFiltro(filtro).then(
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

        $scope.reposicionCajaChica = {}; 

        $scope.reposicionCajaChica = {
            id: new ObjectId().toString(),
            estado: "AB", 
            ciaContabID: $scope.ciaContabSeleccionada.numero,
            docState: 1
        };

        $state.go('reposicionCajaChica.entidad', {});
    };

    $scope.regresarALista = function () {
        $state.go('reposicionCajaChica.lista', {});
    };

    $scope.regresarFiltro = function () {
        $state.go('reposicionCajaChica.filtro', {});
    };


    $scope.setIsEdited = function () {

        if ($scope.reposicionCajaChica.docState)
            return;

        $scope.reposicionCajaChica.docState = 2;
    };

    $scope.grabar = function () {

        // desde grabar lo que hacemos es un click al submit button; la idea es mantener el Grabar en el 'nav bar', pero usar el submit al final 
        setTimeout(function () {
            angular.element('#submitForm_Button').trigger('click');
        }, 0);
    };

    // -------------------------------------------------------------------------
    // nota: solo para asignar nuestra forma (html form) a esta variable; aparentemente, 
    // es una forma de resolver situaciones en las cuales la forma no se 'registra' en el 
    // $scope 

    $scope.form = {}; 

    $scope.submitted = false;

    $scope.reposicionCajaChicaForm_Submit = function () {
        if (!$scope.reposicionCajaChica.docState) {

            DialogModal($modal, "<em>Reposiciones de caja chica</em>",
                "Aparentemente, <em>no se han efectuado cambios</em> en el registro. No hay nada que grabar.", false).then();
            return;
        };

        $scope.submitted = true;

        if (!$scope.form.reposicionCajaChicaForm.$valid)
            return;

        $scope.submitted = false;
        $scope.form.reposicionCajaChicaForm.$setPristine();   

        $scope.showProgress = true;

        DataBaseFunctions.grabarReposicion($scope.reposicionCajaChica).then(
            function (resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                            "(" + resolve.errorMessage + ")"
                    });

                    $scope.showProgress = false;
                    return;
                };

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: resolve.resultMessage
                });

                // nótese como eliminamos el field docState del objeto 

                if ($scope.reposicionCajaChica.docState)
                    delete $scope.reposicionCajaChica.docState;

                $scope.showProgress = false;
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


    
    // --------------------------------------------------------------------------------------
    // ui-grid de Capas 
    // --------------------------------------------------------------------------------------
    var rubroSeleccionado = {};

    $scope.rubros_ui_grid = {
        enableSorting: false,
        showColumnFooter: false,
        enableCellEdit: false,
        enableCellEditOnFocus: true,
        enableRowSelection: true,
        enableRowHeaderSelection: true,
        multiSelect: false,
        enableSelectAll: true,
        selectionRowHeaderWidth: 35,
        rowHeight: 25,
        onRegisterApi: function (gridApi) {
            $scope.capasGridApi = gridApi;

            // guardamos el row que el usuario seleccione 
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                rubroSeleccionado = {};

                if (row.isSelected)
                    rubroSeleccionado = row.entity;
                else
                    return; 
            });

            // marcamos el contrato como actualizado cuando el usuario edita un valor 
            gridApi.edit.on.afterCellEdit($scope, function (rowEntity, colDef, newValue, oldValue) {

                if (newValue != oldValue) 
                    if (!$scope.reposicionCajaChica.docState)
                        $scope.reposicionCajaChica.docState = 2;
            });
        }
    };

    $scope.rubros_ui_grid.columnDefs = [
          {
              name: 'rubroID',
              field: 'rubroID',
              displayName: 'Rubro',
              width: 100,
              editableCellTemplate: 'ui-grid/dropdownEditor',
              editDropdownIdLabel: 'Id',
              editDropdownValueLabel: 'descripcion',
              editDropdownOptionsArray: $scope.rubrosCajaChica,
              cellFilter: 'mapDropdown:row.grid.appScope.rubrosCajaChica:"Id":"descripcion"',
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'string'
          },
          {
              name: 'descripcion',
              field: 'descripcion',
              displayName: 'Descripción',
              enableColumnMenu: false,
              type: 'string',
              headerCellClass: 'ui-grid-leftCell',
              cellClass: 'ui-grid-leftCell',
              width: 150,
              enableCellEdit: true
          },
          {
              name: 'fechaDoc',
              field: 'fechaDoc',
              displayName: 'Fecha doc',
              cellFilter: 'dateFilter',
              width: 100,
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'date'
          },
          {
              name: 'numeroDoc',
              field: 'numeroDoc',
              displayName: 'Número doc',
              enableColumnMenu: false,
              type: 'string',
              headerCellClass: 'ui-grid-leftCell',
              cellClass: 'ui-grid-leftCell',
              width: 150,
              enableCellEdit: true
          },
          {
              name: 'numeroControl',
              field: 'numeroControl',
              displayName: 'Número control',
              enableColumnMenu: false,
              type: 'string',
              headerCellClass: 'ui-grid-leftCell',
              cellClass: 'ui-grid-leftCell',
              width: 150,
              enableCellEdit: true
          },
          {
              name: 'proveedorID',
              field: 'proveedorID',
              displayName: 'Proveedor (Contab)',
              width: 100,
              editableCellTemplate: 'ui-grid/dropdownEditor',
              editDropdownIdLabel: 'Id',
              editDropdownValueLabel: 'abreviatura',
              editDropdownOptionsArray: $scope.companias,
              cellFilter: 'mapDropdown:row.grid.appScope.proveedores:"Id":"abreviatura"',
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'string'
          },
          {
              name: 'proveedor2',
              field: 'proveedor2',
              displayName: 'Proveedor',
              enableColumnMenu: false,
              type: 'string',
              headerCellClass: 'ui-grid-leftCell',
              cellClass: 'ui-grid-leftCell',
              width: 150,
              enableCellEdit: true
          },
          {
              name: 'rif',
              field: 'rif',
              displayName: 'Rif',
              enableColumnMenu: false,
              type: 'string',
              headerCellClass: 'ui-grid-leftCell',
              cellClass: 'ui-grid-leftCell',
              width: 150,
              enableCellEdit: true
          },
          {
              name: 'montoNoImponible',
              field: 'montoNoImponible',
              displayName: 'No imp',
              cellFilter: 'currencyFilter',
              width: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'number'
          },
          {
              name: 'montoImponible',
              field: 'montoImponible',
              displayName: 'Imp',
              cellFilter: 'currencyFilter',
              width: 120,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'number'
          },
          {
              name: 'ivaPorc',
              field: 'ivaPorc',
              displayName: 'Iva (%)',
              cellFilter: 'currencyFilter',
              width: 90,
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'number'
          },
          {
              name: 'iva',
              field: 'iva',
              displayName: 'Iva',
              cellFilter: 'currencyFilter',
              width: 90,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'number'
          }, 
          {
              name: 'total',
              field: 'total',
              displayName: 'Total',
              cellFilter: 'currencyFilter',
              width: 90,
              headerCellClass: 'ui-grid-rightCell',
              cellClass: 'ui-grid-rightCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'number'
          }, 
          {
              name: 'afectaLibroCompras',
              field: 'afectaLibroCompras',
              displayName: 'Afecta libro compras',
              cellFilter: 'boolFilter', 
              width: 90,
              headerCellClass: 'ui-grid-centerCell',
              cellClass: 'ui-grid-centerCell',
              enableSorting: false,
              enableColumnMenu: false,
              enableCellEdit: true,
              type: 'boolean'
          }
    ];


    $scope.agregarGasto = function () {
        if (!_.isArray($scope.reposicionCajaChica.gastos))
            $scope.reposicionCajaChica.gastos = [];
              
        var gasto = {};

        gasto.id = new ObjectId().toString(); 
        gasto.fechaDoc = new Date();

        $scope.reposicionCajaChica.gastos.push(gasto);

        if (!$scope.reposicionCajaChica.docState)
            $scope.reposicionCajaChica.docState = 2;

        $scope.rubros_ui_grid.data = $scope.reposicionCajaChica.gastos; 
    };

    $scope.eliminarGasto = function () {
        // cada vez que el usuario selecciona un row, lo guardamos ... 
        if (rubroSeleccionado) {
            _.remove($scope.reposicionCajaChica.gastos, function (gasto) { return gasto.id === rubroSeleccionado.id; });
              
            if (!$scope.contrato.docState)
                $scope.contrato.docState = 2;
        };
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

        var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/LeerCiaContabSeleccionada?filler=xyz";

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

    factory.aplicarFiltro = function (filtro) {
        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'CajaChica')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/AplicarFiltro";

        var deferred = $q.defer();

        $http.post(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag) {
                    deferred.reject({ number: 0, message: result.resultMessage });
                    return;
                }; 
                    
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


    factory.grabarReposicion = function (reposicionCajaChica) {
        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'CajaChica')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/ActualizarReposicionesCajaChicaWebApi/GrabarItemsAMongo";

        var deferred = $q.defer();

        delete reposicionCajaChica.docState; 

        $http.post(uri, reposicionCajaChica).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag) {
                    deferred.reject({ number: 0, message: result.resultMessage });
                    return;
                };

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


// -----------------------------------------------------------------------------
// modal (popup) para pedir confirmación al usuario
// -----------------------------------------------------------------------------

function DialogModal($modal, titulo, message, showCancelButton) {

    var modalInstance = $modal.open({
        templateUrl: 'genericUIBootstrapModal.html',
        controller: 'DialogModalController',
        size: 'md',
        resolve: {
            titulo: function () {
                return titulo;
            },
            mensaje: function () {
                return message;
            },
            showCancelButton: function () {
                return showCancelButton;
            }
        }
    });

    return modalInstance.result;
};


myApp.controller('DialogModalController', function ($scope, $modalInstance, titulo, mensaje, showCancelButton) {

    $scope.dialogData = {};
    $scope.dialogData.titulo = titulo;
    $scope.dialogData.mensaje = mensaje;
    $scope.dialogData.showCancelButton = showCancelButton;

    $scope.ok = function () {
        $modalInstance.close("Ok");
    };

    $scope.cancel = function () {
        $modalInstance.dismiss("Cancel");
    };
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
