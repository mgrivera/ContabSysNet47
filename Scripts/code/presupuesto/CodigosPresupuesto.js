
"use strict";

var app = angular.module('myApp', ['ui.bootstrap', 'angularUtils.directives.dirPagination']);

app.controller("MainController", function ($scope, $modal, DataBaseFunctions, nedbFunctions) {

    $scope.ciaContabSeleccionada = {};
    $scope.cuentasContables = [];

    // --------------------------------------------------------------------------------
    // al iniciarse la applicación, leemos la cia seleccionada por el usuario ... 
    DataBaseFunctions.leerCiaSeleccionada()
            .success(function (data, status, headers, config) {
                if (data.ErrorFlag) {
                    $scope.ciaContabSeleccionada.cia = null;
                    $scope.ciaContabSeleccionada.nombre = "Indefinida - Seleccione una compañía";
                }
                else {
                    $scope.ciaContabSeleccionada.cia = data.ciaContabSeleccionada;
                    $scope.ciaContabSeleccionada.nombre = data.ciaContabSeleccionadaNombre;
                };

                // --------------------------------------------------------------------------------
                // al iniciarse la applicación, leemos el catálogo de cuentas contables (desde la base de datos
                // local: nedb) 
                
                nedbFunctions.leerCuentasContablesDeLocalDB($scope.ciaContabSeleccionada.cia)
                    .then(function (docs) {
                        $scope.cuentasContables.length = 0;
                        docs.forEach(function (item) {
                            $scope.cuentasContables.push(item); 
                        });
                        $scope.showProgress = false;
                    }, 
                        function (err) {
                            $scope.alerts.length = 0;
                            $scope.alerts.push({
                                type: 'danger',
                                msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor (status code: "
                                + err.toString() +  ")"
                            });
                            $scope.showProgress = false;
                    });

            })
            .error(function (data, status, headers, config) {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor (status code: "
                    + status.toString() + "; error: " + data + ")"
                });
                $scope.showProgress = false;
            });


    $scope.codigosPresupuesto = [];
    $scope.alerts = [];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

    $scope.searchInput = '';
    $scope.mensajeAlUsuario = '';

    $scope.filtro = {};
    $scope.showProgress = true;

    // ------------------------------------------------------------------------------------
    // para recuperar, si existe, el filtro guardado en local storage 
    // ------------------------------------------------------------------------------------
    var myFiltroAnterior = localStorage.getItem("filtro_controlPresupuesto");
    var myFiltroAnterior_Object;

    if (myFiltroAnterior) {
        myFiltroAnterior_Object = JSON.parse(myFiltroAnterior);
        $scope.filtro = _.clone(myFiltroAnterior_Object);
    }
    // ------------------------------------------------------------------------------------

    // ----------------------------------------------------------------------
    // abrimos el modal para que el usuario indique un filtro ... 
    // -----------------------------------------------------------------------------------

    $scope.openModalFiltro = function (size) {

        var modalInstance = $modal.open({
            templateUrl: 'modalFiltro.html',
            controller: 'ModalFiltroController',
            size: size,
            resolve: {
                filtro: function () {
                    return $scope.filtro;
                }
            }
        });

        modalInstance.result.then(
           function (modalReturnValue) {

               angular.extend($scope.filtro, modalReturnValue);
               $scope.showProgress = true; 

               // leemos los códigos desde el servidor, usando el filtro que el usuario indicó ... 

               DataBaseFunctions.leerCodigosDesdeElServidor($scope.filtro, $scope.ciaContabSeleccionada.cia)
                .success(function (data, status) {
                    if (data.ErrorFlag) {
                        $scope.alerts.length = 0;
                        $scope.showProgress = false;
                        $scope.alerts.push({
                            type: 'danger',
                            msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor:  "
                            + data.ErrorMessage
                        });
                    }
                    else {
                        $scope.codigosPresupuesto.length = 0;
                        data.CodigosPresupuesto.forEach(function (item) {

                            var presupuesto = {
                                codigoOriginal: item.Codigo,
                                codigo: item.Codigo,
                                descripcion: item.Descripcion,
                                cantNiveles: item.CantNiveles,
                                grupo: item.GrupoFlag,
                                suspendido: item.SuspendidoFlag,
                                cuentasContables: []
                            };

                            item.CuentasContables.forEach(function (cuenta) {
                                presupuesto.cuentasContables.push({ id: cuenta.ID, cuenta: cuenta.Cuenta, descripcion: cuenta.Descripcion })
                            }); 

                            $scope.codigosPresupuesto.push(presupuesto);
                        });

                        $scope.alerts.length = 0;
                        $scope.alerts.push({ type: 'success', msg: 'Ok, ' + data.CodigosPresupuesto.length.toString() + ' códigos han sido leídos desde el servidor ... ' });
                        $scope.showProgress = false;
                    }
                })
                .error(function (data, status, headers, config) {
                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor (status code: "
                        + status.toString() + "; error: " + data + ")"
                    });
                    $scope.showProgress = false;
                });

               // ---------------------------------------------------------------------
               // guardamos el filtro en local storage 
               localStorage.setItem("filtro_controlPresupuesto", JSON.stringify($scope.filtro));

           }, function (modalCancelValue) {
               var a = modalCancelValue;
           });
    };

    // angular pagination 
    $scope.currentPage = 1;
    $scope.pageSize = 10;


    // -----------------------------------------------------------------------------------
    // para grabar los datos que el usuario ha editado 
    // -----------------------------------------------------------------------------------

    $scope.grabarDatosAlServidor = function () {

        // enviamos al servidor solo items editados 

        var itemsEditados = {};

        itemsEditados = _.filter($scope.codigosPresupuesto, function (item) {
            var editado = false;
            editado = item.isNew || item.isDeleted || item.isEdited;

            return editado;
        });

        // eliminamos iems nuevos que se han eliminados (no existen en el db y el usuario los agregó pero eliminó de inmediato) 

        var itemsEditados2 = _.remove(itemsEditados, function (item) {
            var nuevoYEliminado = false;
            nuevoYEliminado = item.isDeleted && !item.codigoOriginal;       // los items sin codigoOriginal son los agregados por el usuario y no grabados 

            return nuevoYEliminado;
        });

        // finalmente, intentamos reducir los items eliminados, pues solo se necesita su _id para eliminarlos en el servidor 

        var itemsEditados3 = _.map(itemsEditados, function (item) {
            if (!item.isDeleted)
                return item;
            else
                return { isDeleted: true, codigoOriginal: item.codigoOriginal };
        });

        $scope.showProgress = true;

        DataBaseFunctions.grabarItemsEditados(itemsEditados3, $scope.ciaContabSeleccionada.cia)
        .success(function (data, status) {

            if (data.ErrorFlag) {

                $scope.alerts.length = 0;
                $scope.alerts.push({ type: 'danger', msg: data.ErrorMessage });

                $scope.showProgress = false;
                return;
            }

            // nótese como tratamos los items editados según cada tipo de edición (deleted, edited, added) ... 

            // 1) eliminamos del array los items que el usuario ha eliminado ... 
            var removed = _.remove($scope.codigosPresupuesto, function (item) {
                return item.isDeleted;
            });


            var edited = _.chain($scope.codigosPresupuesto)
                        .where({ isEdited: true })
                        .map(function (item) {
                            delete item.isEdited;
                            return item;
                        })
                        .value();

            var added = _.chain($scope.codigosPresupuesto)
                        .where({ isNew: true })
                        .map(function (item) {

                            // nótese como, simplemente, recuperamos el codigoOriginal desde el código que indica el usuario; 
                            // cuando la clave se origina en el servidor (casi cualquier pk), aquí debemos recuperarla desde 
                            // algún array que se regrese desde el servidor y asignarla; en un caso tal, todo es algo más complejo, 
                            // aunque no mucho (ver ejemplo en TiendasWebApp.LibroVentas2 ... 

                            item.codigoOriginal = item.codigo; 

                            // finalmente, y ahora que el item tiene su mongoID, eliminamos las propiedades para que deje de ser nuevo 
                            // eliminamos las propiedades de todo nuevo item  ... 
                            delete item.isNew;
                            delete item.localID;

                            return item;
                        })
                        .value();


            $scope.alerts.length = 0;
            $scope.alerts.push({ type: 'success', msg: data.ResultMessage });
            $scope.showProgress = false;
        })
        .error(function (data, status) {

            $scope.alerts.length = 0;
            $scope.alerts.push({
                type: 'danger',
                msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor (status code: "
                + status.toString() + "; error: " + data + ")"
            });
            $scope.showProgress = false;
        });
    };

    // -----------------------------------------------------------------------------------
    // para actualizar los catálogos (cargar cuentas contables en nedb) 
    // -----------------------------------------------------------------------------------

    $scope.actualizarCatalogos = function () {
        $scope.showProgress = true;
        var promise = DataBaseFunctions.actualizarCatalogos($scope.ciaContabSeleccionada.cia, $scope.cuentasContables);

        promise.then(
            function sucesss(docs) {
                $scope.showProgress = false; 
            },
            function error(err) {
                $scope.alerts.push({
                    type: 'danger',
                    msg: err.message + " - " + err.number
                });
                $scope.showProgress = false;
            }); 
    };


    // -----------------------------------------------------------------------------------
    // abrimos un diálogo que permite asociar y desasociar cuentas contables a las +
    // cuentas de presupuesto 
    // -----------------------------------------------------------------------------------
    $scope.asociarCuentasContables = function (size) {
        var modalInstance = $modal.open({
            templateUrl: 'asociarCuentasContables.html',
            controller: 'CuentasContablesAsociarController',
            size: size,
            resolve: {
                codigosPresupuesto: function () {
                    return $scope.codigosPresupuesto;
                },
                cuentasContables: function () {
                    return $scope.cuentasContables;
                }
            }
        });

        modalInstance.result.then(
           function (modalReturnValue) {
               var a = modalReturnValue; 
           }, function (modalCancelValue) {
               var a = modalCancelValue;
           });
    }; 
    


    // ----------------------------------------------------------------------------
    // elementos para permitir edición en la página 

    $scope.editMode = false;

    // true cuando el usuario ha editado algún dato ... 
    $scope.formHasBeenEdited = function () {
        return _.some($scope.codigosPresupuesto, function (item) { return (item.isNew || item.isEdited || item.isDeleted); });
    }; 
        


    $scope.toggleEditMode = function () {
        $scope.editMode = !$scope.editMode;
    };

    $scope.deleteItem = function (item) {
        if (item.isNew)
        {
            // si el usuario elimina un item que acaba de agregar, y no lo ha guardado al servidor, 
            // simplemente lo eliminamos del array (en vez de 'marcarlo' como eliminado) 
            var codigoPresupuestoEliminado = _.remove($scope.codigosPresupuesto, function (presupuesto) {
                return presupuesto.localID === item.localID; 
            });
            return; 
        }
            
        if (item.isEdited)
            delete item.isEdited;

        item.isDeleted = true;
    };

    $scope.addItem = function () {

        // asignamos un id a los items nuevos, para regresar del servidor y asignar el _id 
        // que crea mongo (usando esta clave local para encontrar cada item) ... 

        var localID = 1;
        var addedItems = _.filter($scope.codigosPresupuesto, function (item) { return item.localID > 0; });      // lodash.filter ... 

        if (addedItems.length) {
            var itemMax = _.max($scope.codigosPresupuesto, 'localID');               // lodash.max
            localID = itemMax.localID + 1;
        }

        $scope.codigosPresupuesto.push({
            //_id: null,
            localID: localID,
            codigo: '',
            descripcion: '',
            cantNiveles: 0,
            grupo: false,
            suspendido: false,
            cuentasContables: [], 
            isNew: true
        });
    };

    $scope.setIsEdited = function (item) {
        if (!item.isNew && !item.isDeleted)
            item.isEdited = true;

        // intentamos determinar la cantidad de niveles 
        if (item.codigo)
        {
            var nivelesCodigoPresupuesto = item.codigo.split("-");
            if (nivelesCodigoPresupuesto && _.isArray(nivelesCodigoPresupuesto) && nivelesCodigoPresupuesto.length > 0)
                item.cantNiveles = nivelesCodigoPresupuesto.length;
        }
            
    };

    $scope.submitted = false;

    $scope.submitMyForm = function submitMyForm() {
        $scope.submitted = true;

        if ($scope.myForm.$valid) {
            // salimos del edit mode, solo cuando la forma es válida 
            $scope.editMode = !$scope.editMode;
            $scope.submitted = false;
            $scope.myForm.$setPristine();    // para que la clase 'ng-submitted deje de aplicarse a la forma ... 
        }
    };

    // ----------------------------------------------------------------------------
});


// controller para el modal: filtro ... 
app.controller('ModalFiltroController', function ($scope, $modalInstance, filtro) {

    $scope.filtro = filtro;

    $scope.ok = function () {
        $modalInstance.close($scope.filtro);
    };

    $scope.cancel = function () {
        $modalInstance.dismiss('the modal was canceled');
    };

    $scope.limpiarFiltro = function () {
        if (filtro.codigo)
            filtro.codigo = null; 

        if (filtro.descripcion)
            filtro.descripcion = null;

        if (filtro.cantNiveles)
            filtro.cantNiveles = null;

        if (filtro.grupo)
            filtro.grupo = "todos";

        if (filtro.suspendido)
            filtro.suspendido = "todos";
    }; 
});

app.controller('CuentasContablesAsociarController', function ($scope, $modalInstance, codigosPresupuesto, cuentasContables) {

    $scope.codigosPresupuesto = _.where(codigosPresupuesto, { grupo: false });
    $scope.cuentasContables = cuentasContables;
    $scope.codigoPresupuestoSeleccionado = {};

    $scope.seleccionarCodigoPresupuesto = function (item) {
        // establecemos el index del código de presupuesto seleccionado ... 
        $scope.codigoPresupuestoSeleccionado = _.chain($scope.codigosPresupuesto).where({ codigo: item.codigo }).first().value();
    };

    $scope.asociarCuentaContable = function (cuentaContableAAsociar) {
        // no asociamos una cuenta que ya exista para la cuenta de presupuesto ... 
        var cuentaContableYaExiste = _.chain($scope.codigoPresupuestoSeleccionado.cuentasContables).where({ id: cuentaContableAAsociar.id }).first().value();

        if (cuentaContableYaExiste)
            return;

        $scope.codigoPresupuestoSeleccionado.cuentasContables.push({
            id: cuentaContableAAsociar.id,
            cuenta: cuentaContableAAsociar.cuentaContable,
            descripcion: cuentaContableAAsociar.descripcion
        });

        // ponemos el código de presupuesto como editado, para que se actualice en el servidor cuando el usuario haga Grabar ... 
        if (!$scope.codigoPresupuestoSeleccionado.isNew) 
            $scope.codigoPresupuestoSeleccionado.isEdited = true; 
    };

    $scope.eliminarCuentaContableAsociada = function(cuentaContableAsociada) { 
        var cuentaContableEliminada = _.remove($scope.codigoPresupuestoSeleccionado.cuentasContables, function(cuenta) { 
            return cuenta.id === cuentaContableAsociada.id; 
        });

        if (!$scope.codigoPresupuestoSeleccionado.isNew)
            if (cuentaContableEliminada && _.isArray(cuentaContableEliminada) && cuentaContableEliminada.length > 0)
                $scope.codigoPresupuestoSeleccionado.isEdited = true; 
    }; 

    $scope.ok = function () {
        $modalInstance.close('normal return value from modal ...');
    };

    $scope.cancel = function () {
        $modalInstance.dismiss('the modal was canceled');
    };
}); 



app.factory("DataBaseFunctions", function ($http, $q) {

    var dataBaseFunctions = {};

    dataBaseFunctions.leerCiaSeleccionada = function () {
        var uri = path + "api/CodigosPresupuestoWebApi/LeerCiaContabSeleccionada";
        return $http.get(uri);
    };

    dataBaseFunctions.leerCodigosDesdeElServidor = function (filter, ciaContabSeleccionada) {
        var filterString = JSON.stringify(filter);
        var uri = path + "api/CodigosPresupuestoWebApi/LeerCodigosPresupuesto?filter=" + filterString + "&ciaContabSeleccionada=" + ciaContabSeleccionada;
        return $http.get(uri);
    };

    dataBaseFunctions.grabarItemsEditados = function (itemsEditados, ciaContabSeleccionada) {
        //var filterString = JSON.stringify(itemsEditados);
        var uri = path + "api/CodigosPresupuestoWebApi/GrabarItemsEditados?ciaContabSeleccionada=" + ciaContabSeleccionada.toString();
        return $http.post(uri, itemsEditados);
    };

    dataBaseFunctions.actualizarCatalogos = function (ciaContabSeleccionada, cuentasContables) {

        var deferred = $q.defer();

        var uri = path + "api/CodigosPresupuestoWebApi/actualizarCatalogos?ciaContabSeleccionada=" + ciaContabSeleccionada;
        $http.get(uri).
            success(function (data, status, headers, config) {

                cuentasContables.length = 0;

                data.CuentasContables.forEach(function (item) {
                    cuentasContables.push({
                        id: item.ID,
                        cuentaContable: item.CuentaContable,
                        descripcion: item.Descripcion,
                        ciaContabAbreviatura: item.CiaAbreviatura,
                        ciaID: ciaContabSeleccionada
                    }); 
                });


                // actualizamos la base de datos local (nedb) con las cuentables que acabamos de leer (para la cia contab seleccionada) 

                var db = {};
                db.cuentasContables = new Nedb({ filename: 'localData/contab_cuentasContables' });

                db.cuentasContables.loadDatabase(function (err) {
                    if (!err) {
                        // muy importante el 'multi' pues, de otra forma, solo un item es eliminado del collection ....
                        db.cuentasContables.remove({ ciaID: ciaContabSeleccionada }, { multi: true }, function (err, docs) {
                            if (!err) {
                                db.cuentasContables.insert(cuentasContables, function (err, newDocs) {
                                    if (!err)
                                        deferred.resolve(newDocs);
                                    else 
                                        deferred.reject({ number: 0, message: err.toString() });
                                });
                            }
                            else
                                deferred.reject({ number: 0, message: err.toString() });
                        });
                    }
                    else 
                        deferred.reject({ number: 0, message: err.toString() });
                    });
            }).
            error(function (data, status, headers, config) {
                // TODO: cómo enviamos el http error message ?? 
                deferred.reject({ number: status, message: "Error al intentar ejecutar http al servidor." });
            });

        return deferred.promise; 
    }; 

    return dataBaseFunctions;
});

app.factory("nedbFunctions", function ($q) {
    // para leer la base de datos 'local' nedb (very similar to mongo but for local). 

    var factory = {};

    factory.leerCuentasContablesDeLocalDB = function (ciaContabSeleccionada) {

        var db = {};
        var deferred = $q.defer(); 

        db.cuentasContables = new Nedb({ filename: 'localData/contab_cuentasContables' }); 

        db.cuentasContables.loadDatabase(function (err) {
            if (err)
                deferred.reject({ errorMessage: 'Error: ha ocurrido un error al intentar leer las cuentas contables ' +
                                        'desde la base de datos local (nedb); por favor revise.' }); 
            else {
                db.cuentasContables.find({ ciaID: ciaContabSeleccionada }).sort({ cuentaContable: 1 }).exec(function (err, docs) {
                    if (err)
                        deferred.reject({ errorMessage: 'Error: ha ocurrido un error al intentar leer las cuentas contables ' +
                                        'desde la base de datos local (nedb); por favor revise.' }); 
                    else
                        deferred.resolve(docs);        // 'docs' es el array de cuentas contables 
                });
            }
        });

        return deferred.promise; 
    };

    return factory;
});

// ---------------------------------------------------------------------------------------
// para mostrar 'unsafe' strings (with embedded html) in ui-bootstrap alerts .... 
// ---------------------------------------------------------------------------------------
app.filter('unsafe', function($sce) {
    return function(value) {
        if (!value) { return ''; }
        return $sce.trustAsHtml(value);
    };
})


