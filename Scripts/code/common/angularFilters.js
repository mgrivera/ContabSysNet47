

// ---------------------------------------------------------------------------------------
// ui-grid: para formatear fields numéricos y dates 
// ---------------------------------------------------------------------------------------
myApp.filter('currencyFilter', function () {
    return function (value) {
        return numeral(value).format('0,0.00');
    };
});


myApp.filter('number8decimals', function () {
    return function (value) {
        if (value)
            return numeral(value).format('0.00000000');
        else
            return "";
    };
});

myApp.filter('number6decimals', function () {
    return function (value) {
        if (value)
            return numeral(value).format('0.000000');
        else
            return "";
    };
});

myApp.filter('currencyFilterAndNull', function () {
    return function (value) {
        if (value)
            return numeral(value).format('0,0.00');
        else
            return "";
    };
});

myApp.filter('dateFilter', function () {
    return function (value) {
        if (value)
            return moment(value).format('DD-MM-YY');
        else
            return "";
    };
});

myApp.filter('dateTimeFilter', function () {
    return function (value) {
        if (value)
            return moment(value).format('DD-MM-YY h:m a');
        else
            return "";
    };
});

myApp.filter('boolFilter', function () {
    return function (value) {
        return value ? "Ok" : "";
    };
});

myApp.filter('tipoContratoFilter', function () {
    return function (tipoContratoID) {
        var tipoContrato = TiposContrato.find(tipoContratoID);
        return !nombreTipoContrato || _.isEmpty(nombreTipoContrato) ? "Indefinido" : tipoContrato.descripcion;
    };
});

myApp.filter('tipoCompaniaFilter', function () {
    return function (tipoCompania) {

        var tiposCompania = [{ descripcion: 'Ajustadores', tipo: 'AJUST' },
                             { descripcion: 'Corredores', tipo: 'CORR' },
                             { descripcion: 'Productores', tipo: 'PROD' },
                             { descripcion: 'Reaseguradores', tipo: 'REA' },
                             { descripcion: 'Compañías de seguro', tipo: 'SEG' }];

        var found = _.find(tiposCompania, function (t) { return t.tipo == tipoCompania; });

        return found ? found.descripcion : "Indefinido";
    };
});

myApp.filter('empresaUsuariaSeleccionadaFilter', function () {
    return function (companiaID) {
        var compania = EmpresasUsuarias.findOne(companiaID, { fields: { nombre: 1 } });
        return !compania || _.isEmpty(compania) ? "Indefinido" : compania.nombre;
    };
});

myApp.filter('companiaAbreviaturaFilter', function () {
    return function (companiaID) {
        var compania = Companias.findOne(companiaID, { fields: { abreviatura: 1 } });
        return !compania || _.isEmpty(compania) ? "Indefinido" : compania.abreviatura;
    };
});

myApp.filter('ramoAbreviaturaFilter', function () {
    return function (ramoID) {
        var ramo = Ramos.findOne(ramoID, { fields: { abreviatura: 1 } });
        return !ramo || _.isEmpty(ramo) ? "Indefinido" : ramo.abreviatura;
    };
});

myApp.filter('coberturaAbreviaturaFilter', function () {
    return function (coberturaID) {
        var cobertura = Coberturas.findOne(coberturaID, { fields: { abreviatura: 1 } });
        return !cobertura || _.isEmpty(cobertura) ? "Indefinido" : cobertura.abreviatura;
    };
});

myApp.filter('aseguradoAbreviaturaFilter', function () {
    return function (aseguradoID) {
        var asegurado = Asegurados.findOne(aseguradoID, { fields: { abreviatura: 1 } });
        return !asegurado || _.isEmpty(asegurado) ? "Indefinido" : asegurado.abreviatura;
    };
});

myApp.filter('tipoContratoAbreviaturaFilter', function () {
    return function (tipoContratoID) {
        var tipoContrato = TiposContrato.findOne(tipoContratoID);
        return !tipoContrato || _.isEmpty(tipoContrato) ? "Indefinido" : tipoContrato.abreviatura;
    };
});

myApp.filter('monedaSimboloFilter', function () {
    return function (monedaID) {
        var moneda = Monedas.findOne(monedaID);
        return !moneda || _.isEmpty(moneda) ? "Indefinido" : moneda.simbolo;
    };
});

myApp.filter('userNameOrEmailFilter', function () {
    return function (userID) {
        if (!userID)
            return "";

        var user = Meteor.users.findOne(userID);
        var userName = 'indefinido';
        if (user)
            if (user.userName)
                userName = user.userName;
            else
                if (_.isArray(user.emails) && user.emails.length && user.emails[0].address)
                    userName = user.emails[0].address;

        return userName;
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

// ---------------------------------------------------------------------------------------
// para mostrar información de pagos para las cuotas de contratos, fac, sntros, etc. 
// ---------------------------------------------------------------------------------------

myApp.filter('origenCuota_Filter', function () {
    return function (value) {
        //debugger; 
        var source = value;
        return source && source.origen && source.numero ? source.origen + "-" + source.numero : "(???)";
    };
});

myApp.filter('cuotaTienePagos_Filter', function () {
    return function (value, scope) {
        //debugger; 
        var row = scope.row.entity;
        var cantPagos = row.pagos ? row.pagos.length : 0;

        return cantPagos ? cantPagos.toString() : "";
    };
});

myApp.filter('cuotaTienePagoCompleto_Filter', function () {
    return function (value, scope) {
        //debugger; 
        var row = scope.row.entity;

        if (!row.pagos || !row.pagos.length)
            // la cuota no tiene pagos; regresamos false (sin un pago completo) 
            return "";

        var completo = _.some(row.pagos, function (pago) { return pago.completo; });

        return completo ? "Si" : "";
    };
});


// -----------------------------------------------------------------------------------------------------------
// nota: lo que sigue es para lograr implementar el comportamiento del dropdownlist en el ui-grid ... 
// -----------------------------------------------------------------------------------------------------------

myApp.filter('mapDropdown', function (uiGridFactory) {
    return uiGridFactory.getMapDrowdownFilter()
});

myApp.factory('uiGridFactory', function ($http, $rootScope) {

    var factory = {};

    /* It returns a dropdown filter to help you show editDropdownValueLabel
     *
     * Parameters:
     *
     * - input: selected input value, it always comes when you select a dropdown value
     * - map: Dictionary containing the catalog info. For example:
     *    $scope.languageCatalog = [ {'id': 'EN', 'description': 'English'}, {'id': 'ES', 'description': 'Español'} ]
     * - idLabel: ID label. For this example: 'id'.
     * - valueLabel: Value label. For this example: 'description'.
     *
     * 1) Configure cellFilter this way at the ui-grid colDef:
     *
     * { field: 'languageId', name: 'Language'), editableCellTemplate: 'ui-grid/dropdownEditor',
     *   editDropdownIdLabel: 'id', editDropdownValueLabel: 'description', 
     *   editDropdownOptionsArray: $scope.languageCatalog,
     *   cellFilter: 'mapDropdown:row:row.grid.appScope.languageCatalog:"id":"description":languageCatalog' },
     *
     * 2) Append this snippet to the controller:
     * 
     * .filter('mapDropdown', function(uiGridFactory) { 
     *    return uiGridFactory.getMapDrowdownFilter()
     * });
     *
     */
    factory.getMapDrowdownFilter = function () {

        return function (input, map, idLabel, valueLabel) {

            if (map != null) {
                for (var i = 0; i < map.length; i++) {
                    if (map[i][idLabel] === input) {
                        return map[i][valueLabel];
                    }
                }
            }
            return "";
        }
    }

    return factory;
});

