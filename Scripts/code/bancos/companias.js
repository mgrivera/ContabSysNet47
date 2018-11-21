
"use strict";

var app = angular.module('myApp', ['ui.bootstrap', 'angularUtils.directives.dirPagination']);

app.controller("MainController", function ($scope, $modal, DataBaseFunctions, CatalogosFijos) {

    $scope.showProgress = false;

    $scope.companias = [];
    $scope.bancos = []; 

    // ----------------------------------------------------------------
    // para leer los bancos desde el servidor 
    var leerBancos = function () {

        $scope.showProgress = true;

        DataBaseFunctions.leerBancos().then(
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

                $scope.bancos = [];
                $scope.bancos = DataBaseFunctions.bancos;

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

    leerBancos(); 
 
    $scope.alerts = [];

    $scope.tiposCompania = CatalogosFijos.tiposCompania; 
    $scope.naturalJuridico = CatalogosFijos.naturalJuridico; 

    // para mostrar la descripción del tipo de compañía  
    $scope.descripcionTipoCompania = function(compania) { 
        var item = _.find($scope.tiposCompania, function(item) { 
            return item.tipo === compania.clienteProveedor;   
        }); 

        return item.descripcion; 
    }; 

    // para mostrar la descripción: natural/jurídico 
    $scope.descripcionNaturalJuridico = function(compania) { 
        var item = _.find($scope.naturalJuridico, function(item) { 
            return item.tipo === compania.naturalJuridico;   
        }); 

        return item.descripcion; 
    }; 


    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

    $scope.searchInput = '';

    // ------------------------------------------------------------------------------------
    // angular pagination 
    $scope.currentPage = 1;
    $scope.pageSize = 10;
    // ----------------------------------------------------------------------------

    // ----------------------------------------------------------------------------
    // elementos para permitir edición en la página 
    // ----------------------------------------------------------------------------

    $scope.editMode = false;

    // true cuando el usuario ha editado algún dato ... 
    $scope.formHasBeenEdited = function () {
        return _.some($scope.companias, function (item) { return (item.isNew || item.isEdited || item.isDeleted); });
    };


    // ----------------------------------------------------------------
    // para leer las compañías desde el servidor 
    $scope.leerCompanias = function() { 

        $scope.showProgress = true;

        DataBaseFunctions.leerCompanias().then(
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

                $scope.companias = [];
                $scope.companias = DataBaseFunctions.companias; 

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

    $scope.abrirCuentasBancariasModal = function (compania) {

            var modalInstance = $modal.open({
                templateUrl: 'actualizarCuentasBancariasModal.html',
                controller: 'actualizarCuentasBancariasController',
                size: 'lg',
                //to pass parameters to the modal controller
                resolve: {
                    compania: function () {
                        return compania;
                    }, 
                    bancos: function () {
                        return $scope.bancos;
                    }
                }
            });

            modalInstance.result.then(
                function success(resolve) {
                    var a = resolve;
                    return;
                },
                function failure(err) {
                    var a = err;
                    return;
                });
        };










    // ----------------------------------------------------------------
    // para grabar a mongo las compañías que el usuario ha editado 
    $scope.grabarDatosAlServidor = function () {

        $scope.showProgress = true;

        DataBaseFunctions.grabarCompanias().then(
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

                $scope.companias = [];
                $scope.companias = DataBaseFunctions.companias;

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: resolve.resultMessage
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

});


app.factory("DataBaseFunctions", function ($http, $q) {

    var factory = {};

    factory.companias = []; 
    factory.bancos = []; 

    factory.leerCompanias = function () {

        var deferred = $q.defer();

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/CompaniasWebApi/LeerCompanias";

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.companias.length = 0; 

                result.companias.forEach(function(item) { 
                    factory.companias.push(item);
                }); 
                
                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({ number: errNumber, message: "Error al intentar ejecutar http (post) al servidor: " + errMessage });
            });

        return deferred.promise;
    };


    factory.leerBancos = function () {

        var deferred = $q.defer();

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/CompaniasWebApi/LeerBancos";

        $http.get(uri).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                factory.bancos.length = 0; 

                result.bancos.forEach(function(item) { 
                    factory.bancos.push(item);
                }); 
                
                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({ number: errNumber, message: "Error al intentar ejecutar http (post) al servidor: " + errMessage });
            });

        return deferred.promise;
    };


    factory.grabarCompanias = function () {

        var deferred = $q.defer();

        // enviamos al server solo los items que se han editado 

        var companiasEditadas = _.filter(factory.companias, function (compania) {
            // solo hay compañías modificadas, no eliminadas ni nuevas (al menos por ahora) ... 
            return compania.isEdited; 
        }); 


        // recorremos companiasEditadas para eliminar del cuentas bancarias las que el usuario haya podido eliminar 

        companiasEditadas.forEach(function(compania) { 
            if (compania.cuentasBancarias) 
                _.remove(compania.cuentasBancarias, function(c) { return c.isDeleted; } ); 
        }); 

        // nótese como obtenemos el (base) uri de la página ... 
        var location = window.location.protocol + "//" + window.location.host + "/";
        var pathArray = window.location.pathname.split('/');
        if (pathArray[1] && pathArray[1] != 'Bancos')        // nótese que queremos ContabSysNet47 y no CajaChica, que es el nombre del 'area' (asp.net mvc) 
            // para obtener el nombre del site, cuando existe; ej: ContabSysNet47 ... 
            // cuando desarrollamos, no existe (ej: http://localhost:5050) 
            location += pathArray[1] + '/';

        var uri = location + "api/CompaniasWebApi/GrabarCompanias";

        $http.post(uri, companiasEditadas).then(
            function (data, status) {

                var result = data.data;

                if (result.errorFlag)
                    deferred.reject({ number: 0, message: result.resultMessage });

                // TODO: 
                // 1) companias: eliminar idEdited property 
                // 2) array cuentas: isNew / isEdited: eliminar; isDeleted: delete item ... 

                //  lodash ... 

                _.chain(factory.companias)
                 .filter(function(c) { return c.isEdited; })
                 .forEach(function(c) {
                        delete c.isEdited; 
                        if (c.cuentasBancarias) {
                            // eliminamos las cuentas bancarias que tengan isDeleted 
                            _.remove(c.cuentasBancarias, function(j) { return j.isDeleted; }); 

                            // eliminamos isEdited/isNew en las cuentas bancarias que tengan estas propiedades 
                            c.cuentasBancarias.forEach(function(i) { 
                                delete i.isEdited; 
                                delete i.isNew; 
                            }); 
                        }; 
                  })
                  .value(); 

                deferred.resolve(result);
            },
            function (data, status) {
                var errNumber = data.status ? data.status : 0;
                var errMessage = data.statusText ? data.statusText : "";

                deferred.reject({ number: errNumber, message: "Error al intentar ejecutar http (post) al servidor: " + errMessage });
            });

        return deferred.promise;
    };



    return factory; 
});

app.factory("CatalogosFijos", function() { 

    var factory = {}; 

    factory.tiposCompania = [ 
        { tipo: 1, descripcion: 'Proveedor' },
        { tipo: 2, descripcion: 'Cliente' }, 
        { tipo: 3, descripcion: 'Ambos' }, 
        { tipo: 4, descripcion: 'Relacionado' }
        ]; 

    factory.naturalJuridico = [ 
        { tipo: 1, descripcion: 'Natural' },
        { tipo: 2, descripcion: 'Juridico' }
        ]; 

    return factory; 

})



app.controller('actualizarCuentasBancariasController', function ($scope, $modalInstance, compania, bancos) {

    $scope.compania = compania;
    $scope.bancos = bancos;

    $scope.editMode = false;

    $scope.toggleEditMode = function () {
        $scope.editMode = !$scope.editMode;
    };

    // posibles tipos del movimiento 
    $scope.tiposCuentasBancaria = [
        { tipo: 'CO', descripcion: 'Corriente' },
        { tipo: 'AH', descripcion: 'Ahorro' },
        { tipo: 'VI', descripcion: 'Visa' },
        { tipo: 'MA', descripcion: 'Master' },
        { tipo: 'AM', descripcion: 'Amex' }
    ];


    // para mostrar la descripción del tipo de la cuenta 
    $scope.mostrarDescripcionTipo = function (tipo) {
        var tipoCuentaBancaria = _.find($scope.tiposCuentasBancaria, function (cuentaBancaria) {
            return cuentaBancaria.tipo === tipo;
        });

        return tipoCuentaBancaria ? tipoCuentaBancaria.descripcion : ''; 
    }


    // para mostrar el nombre del banco ... 
    $scope.mostrarNombreBanco = function (banco) {
        var bancoSeleccionado = _.find($scope.bancos, function (bancoItem) {
            return bancoItem.id === banco;
        });

        return bancoSeleccionado ? bancoSeleccionado.nombre : ''; 
    }


    $scope.agregarCuentaBancaria = function () {

        var cuentaBancaria = {};

        cuentaBancaria.isNew = true;

        if (!$scope.compania.cuentasBancarias)
            $scope.compania.cuentasBancarias = [];

        $scope.compania.cuentasBancarias.push(cuentaBancaria);
        $scope.compania.isEdited = true;
    };


    $scope.setIsEdited = function (cuentaBancaria) {
        $scope.compania.isEdited = true;

        if (!cuentaBancaria.isNew && !cuentaBancaria.isDeleted)
            cuentaBancaria.isEdited = true;
    };

    $scope.deleteItem = function (cuentaBancaria) {
        if (cuentaBancaria.isNew)
            // si un item es nuevo, simplemente lo eliminamos del array ...
            return _.remove($scope.compania.cuentasBancarias, function (item) { return item.numero === cuentaBancaria.numero; });

        if (cuentaBancaria.isEdited)
            delete item.isEdited;

        cuentaBancaria.isDeleted = true;
        $scope.compania.isEdited = true;
    };


    // el usuario hace un submit, cuando quiere 'salir' de edición ...
    $scope.submitted = false;

    $scope.submitMovimientosRiesgoForm = function () {
        $scope.submitted = true;

        if ($scope.movimientosRiesgoForm.$valid) {
            // salimos del edit mode, solo cuando la forma es válida
            $scope.editMode = false;
            $scope.submitted = false;
            $scope.movimientosRiesgoForm.$setPristine();    // para que la clase 'ng-submitted deje de aplicarse a la forma ... button
        }
    };

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
