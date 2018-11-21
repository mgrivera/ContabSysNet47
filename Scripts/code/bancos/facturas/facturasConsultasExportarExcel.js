"use strict";

var app = angular.module('myApp', ['ui.bootstrap']);

app.controller("MainController", function ($scope, $modal, DataStore, ConstruirConsulta) {

    $scope.plantillasLibroCompras = [];
    $scope.plantillasLibroVentas = [];
    $scope.plantillasListaUsuario = [];

    // una vez construido el documento, ponemos aquí el uri para hacer el download con un simple click a un link 
    $scope.uriFileDownload = ""; 

    $scope.opcionesPrograma = [
        { tipo: 'LC', descripcion: 'Libro de compras' },
        { tipo: 'LV', descripcion: 'Libro de ventas' }
    ];

    $scope.showProgress = false;

    // ui-bootstrap alerts ...
    $scope.alerts = [];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };


    var leerDatosInicialesPagina = function () {

        $scope.showProgress = true;

        DataStore.leerPlantillasDocumentosExcel().then(

            function success(resolve) {

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

                $scope.plantillasLibroCompras = DataStore.plantillasLibroCompras;
                $scope.plantillasLibroVentas = DataStore.plantillasLibroVentas;

                // nótese como inicializamos estas variables, para asignar 'defectos' a las listas ... 

                $scope.opcionSeleccionadaPorUsuario = $scope.opcionesPrograma[0];
                $scope.plantillasLibroCompras.forEach(function (item) { $scope.plantillasListaUsuario.push(item) });
                $scope.plantillaSeleccionadaPorUsuario = $scope.plantillasLibroCompras[0];


                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: "Seleccione el <em>tipo de consulta</em> que desea y, luego, la <em>plantilla</em> " +
                         "(<em>Excel</em>) que desea aplicar."
                });

                $scope.showProgress = false;

            },
            function failure(err) {

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + err.message + "; status code: " + err.number.toString() + ")"
                });

                $scope.showProgress = false;

            });
    };

    leerDatosInicialesPagina(); 

  
    // ----------------------------------------------------------------------------------------
    // modal para confirmar alguna acción del usuario
    var dialogModal = function (titulo, message, mostrarCancelButton) {

        var modalInstance = $modal.open({
            templateUrl: 'dialogModalContent.html',
            controller: 'DialogModalController',
            size: 'md',
            //to pass parameters to the modal controller
            resolve: {
                titulo: function () {
                    return titulo;
                },
                mensaje: function () {
                    return message;
                }, 
                mostrarCancelButton: function() { 
                    return mostrarCancelButton; 
                }
            }
        });

        return modalInstance.result;
    };


    // para cargar la lista de 'plantillas' (Excel) cuando el usuario selecciona una opción (libro de compras/ventas) 

    $scope.opcionSeleccionadaPorUsuario = {};
    $scope.plantillaSeleccionadaPorUsuario = "";

    $scope.opcionSeleccionada = function () {

        switch ($scope.opcionSeleccionadaPorUsuario.tipo) {
            case 'LC':
                {
                    $scope.plantillasListaUsuario.length = 0;
                    $scope.plantillasLibroCompras.forEach(function (item) { $scope.plantillasListaUsuario.push(item) });

                    if ($scope.plantillasListaUsuario.length > 0) 
                        $scope.plantillaSeleccionadaPorUsuario = $scope.plantillasListaUsuario[0]; 

                    break;
                }
            case 'LV':
                {
                    $scope.plantillasListaUsuario.length = 0;
                    $scope.plantillasLibroVentas.forEach(function (item) { $scope.plantillasListaUsuario.push(item) });

                    if ($scope.plantillasListaUsuario.length > 0) 
                        $scope.plantillaSeleccionadaPorUsuario = $scope.plantillasListaUsuario[0]; 
                        
                    break;
                }
        }; 
    }; 


    // ---------------------------------------------------------------------------------------------------------
    // para ejecutar la función en el factory (ConstruirConsulta) que construye el documento Excel 
    $scope.construirConsulta = function() { 

        if (!$scope.opcionSeleccionadaPorUsuario || !$scope.plantillaSeleccionadaPorUsuario)
        {
            dialogModal("Seleccione una opción y una plantilla", 
                        "Ud. debe seleccionar una <em><b>opción</em></b> (ejemplo: libro de ventas) " + 
                        "y una <em><b>plantilla</em></b> (Excel).",
                        false);         // nótese que podemos indicar que no se muestre el Cancel button 

            return; 
        };

        $scope.showProgress = true;

        ConstruirConsulta.construirConsulta($scope.opcionSeleccionadaPorUsuario.tipo, $scope.plantillaSeleccionadaPorUsuario).then(

            function success(resolve) {

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


                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: resolve.resultMessage
                });

                // cuando el programa termina de construir la consulta, preparamos el uri que permite hacer el download, con un 
                // simple link 

                // nótese como obtenemos el (base) uri de la página ... 
                var location = window.location.protocol + "//" + window.location.host + "/";
                var pathArray = window.location.pathname.split('/');
                if (pathArray[1] && pathArray[1] != 'Bancos')
            	   // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            	   // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            	   location += pathArray[1] + '/';



                var uri = location + "/api/FacturasConsultaExportarExcelWebApi/DocumentoExcelDownload";
                uri += "?opcionSeleccionada=" + $scope.opcionSeleccionadaPorUsuario.tipo +
                        "&plantillaSeleccionada=" + $scope.plantillaSeleccionadaPorUsuario;

                $scope.uriFileDownload = uri; 

                $scope.showProgress = false;

            },
        function failure(err) {

            $scope.alerts.length = 0;
            $scope.alerts.push({
                type: 'danger',
                msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                    "(" + err.message + "; status code: " + err.number.toString() + ")"
            });

            $scope.showProgress = false;

        });
    };

});


// --------------------------------------------------------------------------------------------------
// factory para ejecutar operaciones de base de datos

app.factory('DataStore', function ($http, $q) {

    var factory = {};

    factory.plantillasLibroCompras = [];
    factory.plantillasLibroVentas = [];

    factory.leerPlantillasDocumentosExcel = function () {

        var deferred = $q.defer();

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';


        var uri = location + "api/FacturasConsultaExportarExcelWebApi/LeerPlantillasExcelDisponibles";

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.plantillasLibroCompras.length = 0;
                factory.plantillasLibroVentas.length = 0;

                result.plantillasLibrosVenta.forEach(function (item) {
                    factory.plantillasLibroVentas.push(item);
                });

                result.plantillasLibroCompras.forEach(function (item) {
                    factory.plantillasLibroCompras.push(item);
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

    return factory;
});



app.factory('ConstruirConsulta', function ($http, $q) {

    var factory = {};

    factory.plantillasLibroCompras = [];
    factory.plantillasLibroVentas = [];

    factory.construirConsulta = function (opcionSeleccionada, plantillaSeleccionada) {

        var deferred = $q.defer();

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';


        var uri = location + "/api/FacturasConsultaExportarExcelWebApi/ConstruirConsulta";
        uri += "?opcionSeleccionada=" + opcionSeleccionada + 
                "&plantillaSeleccionada=" + plantillaSeleccionada; 

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

                deferred.reject({ number: errNumber, message: "Error al intentar ejecutar http (get) al servidor: " + errMessage +
                                                              ". Usando la dirección: " + uri });
            });

        return deferred.promise;
    };

    return factory;
});


// --------------------------------------------------------------------------------------------------
// modal para pedir confirmación al usuario
app.controller('DialogModalController', function ($scope, $modalInstance, titulo, mensaje, mostrarCancelButton) {

    $scope.dialogData = {};
    $scope.dialogData.titulo = titulo;
    $scope.dialogData.mensaje = mensaje;
    $scope.mostrarCancelButton = mostrarCancelButton; 

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
app.filter('unsafe', function ($sce) {
    return function (value) {
        if (!value) { return ''; }
        return $sce.trustAsHtml(value);
    };
});