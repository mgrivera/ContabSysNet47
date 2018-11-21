
"use strict";

var app = angular.module('myApp', ['ui.bootstrap', 'angularUtils.directives.dirPagination']);

app.controller("MainController", function ($scope, $modal, DataBaseFunctions, DatosIniciales, MontosEstimadosFactory) {

    var leerDatosIniciales = DatosIniciales.leerDatosIniciales();

    $scope.showProgress = true;
    $scope.montosEstimados = [];

    $scope.ciaContabSeleccionada = {};
    
    leerDatosIniciales.then(
        function success(resolve) {

            if (resolve.errorFlag) {

                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " +
                        "(" + result.resultMessage + ")"
                });

                $scope.showProgress = false;
                return; 
            }; 
            
            $scope.ciaContabSeleccionada = DatosIniciales.ciaContabSeleccionada;

            $scope.showProgress = false;
        },
        function failure(err) {

            $scope.alerts.length = 0;
            $scope.alerts.push({
                type: 'danger',
                msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor " + 
                    "(" + err.message + "; status code: " + err.number.toString() +  ")"
            });

            $scope.showProgress = false;
        });


    $scope.alerts = [];

    $scope.closeAlert = function (index) {
        $scope.alerts.splice(index, 1);
    };

    $scope.searchInput = '';

    $scope.filtro = {};
    $scope.showProgress = true;

    // ------------------------------------------------------------------------------------
    // para recuperar, si existe, el filtro guardado en local storage 
    // ------------------------------------------------------------------------------------
    var myFiltroAnterior = localStorage.getItem("filtro_montosEstimados");
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

               // ------------------------------------------------------------------------------------------------
               // al regresar del filtro, ejecutamos la función que lee y regresa los códigos de presupuesto. 
               // en la función que permite indicar el filtro, hacemos una referencia a $scope.filtro; cuando 
               // regresamos aquí, allí tenemos el filtro que indicó el usuario y lo pasamos a la función 
               // que lee los códigos de presupuesto 

               $scope.showProgress = true;

               var montosEstimadosFactory = MontosEstimadosFactory.leerMontosEstimados($scope.filtro);
               montosEstimadosFactory.then(
                   function(resolve) {
                       if (resolve.errorFlag) { 

                           $scope.alerts.length = 0;
                           $scope.alerts.push({
                               type: 'danger',
                               msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor;<br /> " +
                                   "el mensaje específico del error es: " + resolve.resultMessage + "."
                           });

                           $scope.showProgress = false;
                           return; 
                       }; 

                       $scope.montosEstimados = MontosEstimadosFactory.montosEstimados;

                       $scope.alerts.length = 0;
                       $scope.alerts.push({
                           type: 'success', msg: 'Ok, ' + $scope.montosEstimados.length.toString() +
                                 ' registros (montos estimados) han sido leídos desde el servidor ... '
                       });
                       $scope.showProgress = false;
                        
                       $scope.showProgress = false;
                   }, 
                   function(err) {

                       $scope.alerts.length = 0;
                       $scope.alerts.push({
                           type: 'danger',
                           msg: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor;<br /> " +
                               "el mensaje específico del error es: " + err.message + " (status: " + err.number.toString() + ")."
                       });

                       $scope.showProgress = false;
                   }); 

               // ---------------------------------------------------------------------
               // guardamos el filtro en local storage 
               localStorage.setItem("filtro_montosEstimados", JSON.stringify($scope.filtro));

           }, function (modalCancelValue) {
               var a = modalCancelValue;
           });
    };

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
        return _.some($scope.montosEstimados, function (item) { return (item.isNew || item.isEdited || item.isDeleted); });
    };

    $scope.toggleEditMode = function () {
        $scope.editMode = !$scope.editMode;
    };

    $scope.deleteItem = function(item) { 
        MontosEstimadosFactory.deleteItem(item); 
    }; 
    
    $scope.addItem = function() { 
        MontosEstimadosFactory.addItem(); 
    }; 
    
    $scope.setIsEdited = function(item) { 
        MontosEstimadosFactory.setIsEdited(item); 
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
    
    $scope.grabarDatosAlServidor = function () {

        $scope.showProgress = true;

        MontosEstimadosFactory.grabarItemsEditados().then(
            function success(resolve) {

                if (resolve.errorFlag) {

                    $scope.alerts.length = 0;
                    $scope.alerts.push({ type: 'danger', msg: resolve.resultMessage });

                    $scope.showProgress = false;
                    return;
            }

            $scope.alerts.length = 0;
            $scope.alerts.push({ type: 'success', msg: resolve.resultMessage });

            $scope.showProgress = false;
        }, 
            function failure(err) {

            $scope.alerts.length = 0;
            $scope.alerts.push({ type: 'danger', msg: resolve.resultMessage });

            $scope.showProgress = false;
        });
    };


    // ---------------------------------------------------------------------------------------
    // modal para la ejecución de funciones sobre los registros de montos estimados 
    // ---------------------------------------------------------------------------------------

    $scope.openFuncionesModal = function (size) {

        var modalInstance = $modal.open({
            templateUrl: 'funcionesModalTemplate.html',
            controller: 'FuncionesModalController',
            size: size 
            //resolve: {
            //    filtro: function () {
            //        return $scope.filtro;
            //    }
            //}
        });

        modalInstance.result.then(
           function () {

               // nótese que, en particular para este modal (agregar y ajustar montos estimados), no regresamos aquí con un valor, etc.
               // simplemente, el proceso se efectúa todo en el modal hasta que el usuario lo cierra 

           }, function (modalCancelValue) {
               var a = modalCancelValue;
           });
    };
});



// ----------------------------------------------------------------------------------------------------
// Factory: para leer los datos iniciales de la página: cia y monedas 
// ----------------------------------------------------------------------------------------------------
app.factory("DatosIniciales", function ($http, $q) {

    var factory = {};

    factory.ciaContabSeleccionada = {};
    factory.monedas = [];
    factory.anos = []; 

    factory.leerDatosIniciales = function () {

        var deferred = $q.defer();

        var uri = path + "api/MontosEstimadosWebApi/LeerDatosIniciales";
        $http.get(uri).
            success(function (data, status, headers, config) {

                if (!data.ErrorFlag) {
                    factory.ciaContabSeleccionada = {};
                    factory.ciaContabSeleccionada = _.clone(data.ciaContabSeleccionada);

                    data.monedas.forEach(function (item) {
                        factory.monedas.push(item);
                    });

                    _.sortBy(data.anos, function(ano) { return ano }).forEach(function(ano) { 
                        factory.anos.push(ano); 
                    }); 
                };

                deferred.resolve({ errorFlag: data.ErrorFlag, resultMessage: data.ResultMessage });
            }).
            error(function (data, status, headers, config) {
                deferred.reject({ number: status, message: "Error al intentar ejecutar http al servidor." });
            });

        return deferred.promise;
    };

    return factory;
});

// ----------------------------------------------------------------------------------------------------
// Factory: para leer los códigos de presupuesto en el servidor 
// ----------------------------------------------------------------------------------------------------
app.factory("MontosEstimadosFactory", function ($http, $q, DatosIniciales) {

    var factory = {};

    // constructor para crear montos estimados 
    var MontoEstimado = function (item) {
        this.codigo = item.Codigo;
        this.descripcion = item.Descripcion;
        this.moneda = item.Moneda;
        this.monedaSimbolo = item.MonedaSimbolo;
        this.ano = item.Ano;
        this.mes01_est = item.Mes01_Est;
        this.mes02_est = item.Mes02_Est;
        this.mes03_est = item.Mes03_Est;
        this.mes04_est = item.Mes04_Est;
        this.mes05_est = item.Mes05_Est;
        this.mes06_est = item.Mes06_Est;
        this.mes07_est = item.Mes07_Est;
        this.mes08_est = item.Mes08_Est;
        this.mes09_est = item.Mes09_Est;
        this.mes10_est = item.Mes10_Est;
        this.mes11_est = item.Mes11_Est;
        this.mes12_est = item.Mes12_Est; 
    }; 
    

    factory.montosEstimados = [];

    // --------------------------------------------------------------------------------------------
    // para leer, usando un filtro, los montos estimados en el servidor 
    // --------------------------------------------------------------------------------------------

    factory.leerMontosEstimados = function (filtro) {

        var deferred = $q.defer();

        // siempre enviamos la cia contab seleccionada como parte del filtro ... 
        filtro.cia = DatosIniciales.ciaContabSeleccionada.ciaContabSeleccionada; 

        var filtroString = JSON.stringify(filtro); 

        var uri = path + "api/MontosEstimadosWebApi/LeerCodigosPresupuesto";
        $http.post(uri, filtroString).
            success(function (data, status, headers, config) {

                if (!data.ErrorFlag) {
                    
                    factory.montosEstimados.length = 0;

                    if (data.MontosEstimados && _.isArray(data.MontosEstimados))
                        data.MontosEstimados.forEach(function (item) {
                            factory.montosEstimados.push(new MontoEstimado(item));
                        });
                };

                deferred.resolve({ errorFlag: data.ErrorFlag, resultMessage: data.ResultMessage });
            }).
            error(function (data, status, headers, config) {
                deferred.reject({ number: status, message: "Error al intentar ejecutar http al servidor." });
            });

        return deferred.promise;
    };


    // los siguientes métodos ayudan al usuario a 'editar' los items en la página 

    factory.deleteItem = function (item) {
        if (!item) 
            return; 

        if (item.isNew) {
            // si el usuario elimina un item que acaba de agregar, y no lo ha guardado al servidor, 
            // simplemente lo eliminamos del array (en vez de 'marcarlo' como eliminado) 
            var deletedItems = _.remove(factory.montosEstimados, function (montoEstimado) {
                return montoEstimado.localID === item.localID;
            });
            return;
        }; 

        if (item.isEdited)
            delete item.isEdited;

        item.isDeleted = true;
    };

    factory.addItem = function () {

        // asignamos un id a los items nuevos, para regresar del servidor y asignar el _id 
        // que crea mongo (usando esta clave local para encontrar cada item) ... 

        var localID = 1;
        var addedItems = _.filter(factory.montosEstimados, function (item) { return item.localID > 0; });      // lodash.filter ... 

        if (addedItems.length) {
            var itemMax = _.max(factory.montosEstimados, 'localID');               // lodash.max
            localID = itemMax.localID + 1;
        }; 

        var newItem = {
            Codigo:  "",
            Descripcion: "",
            Moneda:  0,
            MonedaSimbolo: "",
            Ano:  0,
            Mes01_Est:  0,
            Mes02_Est:  0,
            Mes03_Est:  0,
            Mes04_Est:  0,
            Mes05_Est:  0,
            Mes06_Est:  0,
            Mes07_Est:  0,
            Mes08_Est:  0,
            Mes09_Est:  0,
            Mes10_Est:  0,
            Mes11_Est:  0,
            Mes12_Est:  0
        }; 

        // siempre usamos el 'constructor' para agregar el item al array 
        factory.montosEstimados.push( new MontoEstimado(newItem) );

        // siempre agregamos un valor adicional, que corresponde a una clave 'local' que tienen los 
        // items que el usuario agrega (nota: los items que son leídos de la base de datos traen su 
        // clave propia, que es el pk en la base de datos ... 

        var addedItem = _.last(factory.montosEstimados); 

        addedItem.isNew = true; 
        addedItem.localID = localID; 
        };

    factory.setIsEdited = function (item) {
        if (!item) 
            return; 
        if (!item.isNew && !item.isDeleted)
            item.isEdited = true;
    };

    // para grabar las modificaciones al servidor 

    factory.grabarItemsEditados = function () {

        var deferred = $q.defer();

        // enviamos al servidor solo items editados 

        var itemsEditados = {};

        itemsEditados = _.filter(factory.montosEstimados, function (item) {
            var editado = false;
            editado = item.isNew || item.isDeleted || item.isEdited;

            return editado;
        });

        // eliminamos iems nuevos que se han eliminados (no existen en el db y el usuario los agregó pero eliminó de inmediato) 

        var itemsEditados2 = _.remove(itemsEditados, function (item) {
            var nuevoYEliminado = false;
            nuevoYEliminado = item.isDeleted && item.isNew;  

            return nuevoYEliminado;
        });

        // finalmente, intentamos reducir los items eliminados, pues solo se necesita su _id para eliminarlos en el servidor 

        var itemsEditados3 = _.map(itemsEditados, function (item) {
            if (!item.isDeleted)
                return item;
            else
                return { isDeleted: true, codigo: item.codigo, moneda: item.moneda, ano: item.ano };
        });
        
        var ciaContab = DatosIniciales.ciaContabSeleccionada.ciaContabSeleccionada; 
        var uri = path + "api/MontosEstimadosWebApi/GrabarItemsEditados?ciaContabSeleccionada=" + ciaContab.toString();

        $http.post(uri, itemsEditados3)
            .success(function (data, status) {

                if (data.ErrorFlag) {
                    deferred.reject( {errorFlag: true, resultMessage: data.ResultMessage} ); 
                    return;
                }; 

                // nótese como tratamos los items editados según cada tipo de edición (deleted, edited, added) ... 

                // 1) eliminamos del array los items que el usuario ha eliminado ... 
                var removed = _.remove(factory.montosEstimados, function (item) {
                    return item.isDeleted;
                });


                var edited = _.chain(factory.montosEstimados)
                            .where({ isEdited: true })
                            .map(function (item) {
                                delete item.isEdited;
                                return item;
                            })
                            .value();

                var added = _.chain(factory.montosEstimados)
                            .where({ isNew: true })
                            .map(function (item) {
                                delete item.isNew;
                                delete item.localID;

                                return item;
                            })
                            .value();

                deferred.resolve({errorFlag: false, resultMessage: data.ResultMessage}); 
            })
           .error(function (data, status) {

                deferred.reject({
                    errorFlag: true,
                    resultMessage: "Ha ocurrido un error al intentar ejecutar una función de base de datos en el servidor (status code: "
                    + status.toString() + "; error: " + data + ")"
                });

            });

        return deferred.promise; 
    };

    factory.agregarRegistrosMontosEstimados = function (parametros) {

        var deferred = $q.defer();

        var uri = path + "api/MontosEstimadosWebApi/AgregarMontosEstimados";
        $http.post(uri, parametros).
            success(function (data, status) {
                deferred.resolve({ errorFlag: data.ErrorFlag, resultMessage: data.ResultMessage });
            }).
            error(function (data, status) {
                deferred.reject({ number: status, message: "Error al intentar ejecutar http al servidor." });
            });

        return deferred.promise;

    };

    factory.ajustarRegistrosSegunPorcentaje = function (porcentaje) {

    };

    return factory;
});


// ----------------------------------------------------------------------------------------------------
// controller para el modal filtro 
// ----------------------------------------------------------------------------------------------------

app.controller('ModalFiltroController', function ($scope, $modalInstance, DatosIniciales, filtro) {

    $scope.filtro = filtro;
    $scope.anos = DatosIniciales.anos;
    $scope.monedas = DatosIniciales.monedas;

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

        if (filtro.monedas && _.isArray(filtro.monedas))
            filtro.monedas.length = 0;

        if (filtro.anos && _.isArray(filtro.anos))
            filtro.anos.length = 0;
    };
});


// -----------------------------------------------------------------------------------------------
// controler para el modal para la ejecución de funciones sobre los registros de montos estimados
// -----------------------------------------------------------------------------------------------

app.controller('FuncionesModalController', function ($scope, $modalInstance, MontosEstimadosFactory, DatosIniciales) {

    $scope.showProgress = false;
    $scope.alerts = []; 
    
    $scope.agregarMontos_helpInfo = true;
    $scope.ajustarMontos_helpInfo = true;

    $scope.anos = DatosIniciales.anos;
    $scope.monedas = DatosIniciales.monedas;

    $scope.agregarMontos_Parametros = {};
    $scope.ajustarMontos_Parametros = {};

    $scope.agregarMontos_Parametros.actualizarMontosSiExisten = true; 
    $scope.agregarMontos_Parametros.aplicarSoloAMontosSeleccionados = false;

    $scope.agregarMontosEstimadosForm_submitted = false; 

    $scope.agregarMontosEstimadosForm_submit = function (agregarMontosEstimadosForm) {

        $scope.agregarMontosEstimadosForm_submitted = true; 
        $scope.agregarMontosEstimadosForm = agregarMontosEstimadosForm; 

        if ($scope.agregarMontosEstimadosForm.$valid) {

            $scope.agregarMontosEstimadosForm_submitted = false;
            $scope.agregarMontosEstimadosForm.$setPristine();    // para que la clase 'ng-submitted deje de aplicarse a la forma ... 

            $scope.agregarMontos_Parametros.ciaContabSeleccionada = DatosIniciales.ciaContabSeleccionada.ciaContabSeleccionada;

            // nótese como la moneda que viene desde el select es un objeto (moneda, descripción, simbolo); pasamos solo el id 
            if ($scope.agregarMontos_Parametros.moneda)
                $scope.agregarMontos_Parametros.monedaID = $scope.agregarMontos_Parametros.moneda.Moneda;

            $scope.agregarMontosEstimados($scope.agregarMontos_Parametros);
        } 
        else {
            $scope.alerts.length = 0;
            $scope.alerts.push({
                type: 'danger', 
                msg: "Aparentemente, los datos necesarios para la ejecución de esta función, no son completos o son inválidos."
            });
        }; 
    }; 

    $scope.agregarMontosEstimados = function (parametros) {

        $scope.showProgress = true;

        var agregarMontosEstimados = MontosEstimadosFactory.agregarRegistrosMontosEstimados(parametros);
        agregarMontosEstimados.then(
            function success(resolve) {

                if (resolve.errorFlag) 
                {
                    $scope.alerts.length = 0;
                    $scope.alerts.push({
                        type: 'danger',
                        msg: resolve.resultMessage
                    });

                    $scope.showProgress = false; 
                    return; 
                }

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
                    msg: err.message
                });

                $scope.showProgress = false;
            });
    };


    $scope.ajustarMontosEstimadosForm_submitted = false; 

    $scope.ajustarMontosEstimadosForm_submit = function (ajustarMontosEstimadosForm) {

        $scope.ajustarMontosEstimadosForm_submitted = true; 
        $scope.ajustarMontosEstimadosForm = ajustarMontosEstimadosForm; 

        if ($scope.ajustarMontosEstimadosForm.$valid) {
            $scope.ajustarMontosEstimadosForm_submitted = false;
            $scope.ajustarMontosEstimadosForm.$setPristine();    // para que la clase 'ng-submitted deje de aplicarse a la forma ... 

            $scope.showProgress = true;

            var resultMessage = $scope.ajustarMontosEstimados($scope.ajustarMontos_Parametros.porcentaje);

            if (!resultMessage.errorFlag)
            {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'info',
                    msg: resultMessage.message
                });
            }
            else
            {
                $scope.alerts.length = 0;
                $scope.alerts.push({
                    type: 'danger',
                    msg: resultMessage.message
                });
            }

            $scope.showProgress = false;
        }
        else {
            $scope.alerts.length = 0;
            $scope.alerts.push({
                type: 'danger', 
                msg: "Aparentemente, los datos necesarios para la ejecución de esta función, no son completos o son inválidos."
            });
        };  
    }; 


    $scope.ajustarMontosEstimados = function (porcentaje) {

        // para ajustar los montos estimados, simplemente leemos los montos estimados seleccionados en la página y aplicamos el porcentaje 
        // que indicó el usuario en la forma 

        // validamos que el porcentaje sea un valor correcto ... 

        if (!_.isNumber(porcentaje) || _.isNaN(porcentaje))
            // nótese que _.IsNumber(NaN) es true 
            return { errorFlag: true, message: 'El valor indicado para el porcentaje no es correcto. Por favor revise.' };  

        if (porcentaje < -100 || porcentaje > 100)
            return { errorFlag: true, message: 'El valor indicado para el porcentaje no es correcto. Por favor revise.' };

        // ajustamos los montos estimados, en base al porcentaje indicado 

        var porcentaje2 = porcentaje / 100; 

        _.map(MontosEstimadosFactory.montosEstimados, function (item) {

            if (item.isDeleted)
                return item; 

            if (_.isNumber(item.mes01_est) || !_.isNaN(item.mes01_est)) item.mes01_est += (item.mes01_est * porcentaje2);
            if (_.isNumber(item.mes02_est) || !_.isNaN(item.mes02_est)) item.mes02_est += (item.mes02_est * porcentaje2);
            if (_.isNumber(item.mes03_est) || !_.isNaN(item.mes03_est)) item.mes03_est += (item.mes03_est * porcentaje2);
            if (_.isNumber(item.mes04_est) || !_.isNaN(item.mes04_est)) item.mes04_est += (item.mes04_est * porcentaje2);
            if (_.isNumber(item.mes05_est) || !_.isNaN(item.mes05_est)) item.mes05_est += (item.mes05_est * porcentaje2);
            if (_.isNumber(item.mes06_est) || !_.isNaN(item.mes06_est)) item.mes06_est += (item.mes06_est * porcentaje2);
            if (_.isNumber(item.mes07_est) || !_.isNaN(item.mes07_est)) item.mes07_est += (item.mes07_est * porcentaje2);
            if (_.isNumber(item.mes08_est) || !_.isNaN(item.mes08_est)) item.mes08_est += (item.mes08_est * porcentaje2);
            if (_.isNumber(item.mes09_est) || !_.isNaN(item.mes09_est)) item.mes09_est += (item.mes09_est * porcentaje2);
            if (_.isNumber(item.mes10_est) || !_.isNaN(item.mes10_est)) item.mes10_est += (item.mes10_est * porcentaje2);
            if (_.isNumber(item.mes11_est) || !_.isNaN(item.mes11_est)) item.mes11_est += (item.mes11_est * porcentaje2);
            if (_.isNumber(item.mes12_est) || !_.isNaN(item.mes12_est)) item.mes12_est += (item.mes12_est * porcentaje2);

            item.isEdited = true; 

            return item; 
        }); 

        
        return { errorFlag: false, 
                 message: 'Ok, los montos estimados han sido ajustados según el porcentaje indicado; <br />' + 
                          'Recuerde que Ud. debe cerrar este diálogo y grabar los registros, para que el cambio sea permanente.' };
    }; 

    $scope.cancel = function () {
        $modalInstance.dismiss('the modal was canceled');
    };
});


app.factory("DataBaseFunctions", function ($http, $q) {

    var dataBaseFunctions = {};

    dataBaseFunctions.leerCodigosDesdeElServidor = function (filter, ciaContabSeleccionada) {
        var filterString = JSON.stringify(filter);
        var uri = path + "api/CodigosPresupuestoWebApi/LeerCodigosPresupuesto?filter=" + filterString + "&ciaContabSeleccionada=" + ciaContabSeleccionada;
        return $http.get(uri);
    };

    return dataBaseFunctions;
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
