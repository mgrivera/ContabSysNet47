
var Factura = function (item) {
    var self = this;

    self.cliente = item.Cliente;
    self.rif = item.Rif;
    self.apellidoPropietario = item.ApellidoPropietario;
    self.nombrePropietario = item.NombrePropietario;
    self.telefono = item.Telefono;
    self.celular = item.Celular;
    self.email = item.Email;
    self.direccion = item.Direccion;
    self.ciudad = item.Ciudad;
    self.estado = item.Estado;
    self.vigDesde = item.VigDesde ? moment(item.VigDesde, "DD-MM-YYYY").format("YYYY-MM-DD") : null;
    self.vigHasta = item.VigHasta ? moment(item.VigHasta, "DD-MM-YYYY").format("YYYY-MM-DD") : null;
    self.certificado = item.Certificado;
    self.certAsoc = item.CertAsoc;
    self.representante = item.Representante;
    self.marcaModeloVersion = item.MarcaModeloVersion;
    self.placa = item.Placa;
    self.membresia = numeral(numeral().unformat(item.Membresia)).value();
    self.arysVial = numeral(numeral().unformat(item.ArysVial)).value();
    self.fechaRegistro = item.FechaRegistro ? moment(item.FechaRegistro, "DD-MM-YYYY").format("YYYY-MM-DD") : null;
    self.estatus = item.Estatus;
    self.fecBaja = item.FecBaja ? moment(item.FecBaja, "DD-MM-YYYY").format("YYYY-MM-DD") : null;

    // los montos vienen con Iva calculado; determinamos y separamos los montos de Iva 

    var factor = viewModel.ivaPorc == 0 ? 1 : (1 + (viewModel.ivaPorc / 100));               // ejemplo: para 12% -> (1 / .12) -> 1.12 

    self.membresiaBase = +(self.membresia / factor).toFixed(2);
    self.membresiaIva = +(self.membresia - self.membresiaBase).toFixed(2);

    self.arysVialBase = +(self.arysVial / factor).toFixed(2);
    self.arysVialIva = +(self.arysVial - self.arysVialBase).toFixed(2);
}

var FacturaPage = function (item) {
    var self = this;

    self.cliente = ko.observable(item.cliente);
    self.rif = ko.observable(item.rif);
    self.apellidoPropietario = ko.observable(item.apellidoPropietario);
    self.nombrePropietario = ko.observable(item.nombrePropietario);
    self.telefono = ko.observable(item.telefono);
    self.celular = ko.observable(item.celular);
    self.email = ko.observable(item.email);
    self.direccion = ko.observable(item.direccion);
    self.ciudad = ko.observable(item.ciudad);
    self.estado = ko.observable(item.estado);
    self.certificado = ko.observable(item.certificado);
    self.certAsoc = ko.observable(item.certAsoc);
    self.representante = ko.observable(item.representante);
    self.marcaModeloVersion = ko.observable(item.marcaModeloVersion);
    self.placa = ko.observable(item.placa);

    self.membresia = ko.observable(item.membresia);
    self.arysVial = ko.observable(item.arysVial);

    self.existeEnContab = ko.observable(null); 
}

var ViewModel = function () {

    var self = this;

    self.facturas = new Array();
    self.facturasPage = ko.observableArray();
    self.companiasQueExisten = new Array();             // cuando el usaurio ejecuta el paso Validar, guardamos aquí el rif de compañías que ya existen 

    self.tiposCompania = ko.observableArray([{ id: 0, descripcion: "" }]);
    self.monedas = ko.observableArray([{ id: 0, descripcion: "" }]);
    self.cargos = ko.observableArray([{ id: 0, descripcion: "" }]);
    self.formasPago = ko.observableArray([{ id: 0, descripcion: "" }]);
    self.titulos = ko.observableArray();
    self.cuentasContables = ko.observableArray();
    self.tiposAsiento = ko.observableArray();

    self.tiposCompaniaSeleccionado = ko.observable(); 
    self.monedaSeleccionada = ko.observable();
    self.cargoSeleccionado = ko.observable();
    self.formasPagoSeleccionada = ko.observable();
    self.tituloSeleccionado = ko.observable();

    self.ciaContabSeleccionada = ko.observable();
    self.ciaContabSeleccionadaNombre = ko.observable();
    self.ivaPorc = new Number(); 

    self.fechaFacturas = ko.observable();
    self.cantidadFacturasARegistrar = ko.observable();
    self.numeroLote = ko.observable();

    self.parametrosAgregarAsientosContables = {
        ciaContabSeleccionada: ko.observable(),
        cuentaContable_cxcClientes: ko.observable(),
        cuentaContable_IngMembresia: ko.observable(),
        cuentaContable_IngGrua: ko.observable(),
        cuentaContable_ImpIva: ko.observable(),
        factorCambio: ko.observable(),
        tipoAsientoContable: ko.observable()
    }
}

var viewModel = new ViewModel(); 

ko.applyBindings(viewModel);

// -----------------------------------------------------------------------------
// para leer la compañía seleccionada al abrirse la página ... 
// -----------------------------------------------------------------------------

(function () {

    // leemos los datos iniciales de la página desde el servidor ...
    // path contiene el uri de la aplicación (ej: http://localhost:15590); el código que lo inicializa está en _Layout.cshtml
    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/LeerCiaContabSeleccionada?parametros=nothing";

    $.getJSON(uri)
        .done(function (result) {

            $(".mensajeAlUsuario").html("");

            if (result.ErrorFlag) {
                $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
                return false;
            }

            viewModel.ciaContabSeleccionada(result.ciaContabSeleccionada);
            viewModel.ciaContabSeleccionadaNombre(result.ciaContabSeleccionadaNombre);
            viewModel.ivaPorc = result.ivaPorc; 
        })
        .fail(function (jqxhr, textStatus, error) {
            var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
            errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
            $(".mensajeAlUsuario").addClass("errorMessage").html(errMessage);
        });
})();



// -----------------------------------------------------------------------------
// cuando el usuario hace un click en los controles que permiten leer el archivo, en realidad hacemos un  
// click al input ... 

$(function () {

    // fire the actual input click
    $("#fake-upload-button, #fake-upload-button2").click(function () {
        $("#fileInput").click();
    });
});

// *************************************************************************************************************************
// para recibir el file cuando el usuario selecciona una mediante el "input type='file'" 
// *************************************************************************************************************************

function tratarArchivosSeleccionados(files) {
    handleFile(files);
}


function handleFile(e) {
    var files = e.target.files;
    var i, f;
    for (i = 0, f = files[i]; i != files.length; ++i) {
        var reader = new FileReader();
        var name = f.name;
        reader.onload = function (e) {
            var data = e.target.result;

            var workbook = XLSX.read(data, { type: 'binary' })
            var result = {};

            result = to_json(workbook);

            viewModel.facturas.length = 0;
            viewModel.facturasPage.removeAll(); 

            result.Membresia.forEach(function (item, idx) {
                viewModel.facturas.push(new Factura(item));
            });

            // finalmente, pasamos a un 2do. array, 20 facturas, para mostrar la 1ra. página al usuario ... 
            var i = 1; 
            viewModel.facturas.every(function (item, idx) {
                viewModel.facturasPage.push(new FacturaPage(item));
                i++;
                return (!(i == 20))
            });

            // ------------------------------------------------------------------------------------------------------------------------------
            // nótese como inicializamos el (bootstrap) pager 
            var cantidadPaginas = 0;
            var pageSize = 16; 
            var maxVisiblePages = 8;        // inicialmente, asumimos un máximo de páginas visibles en el pager de 8 
            var numberOfRows = viewModel.facturas.length; 

            if (viewModel.facturas.length > 0) {
                cantidadPaginas = (numberOfRows % pageSize === 0) ? (numberOfRows / pageSize) : ((Math.floor(numberOfRows / pageSize)) + 1);

                if (cantidadPaginas < 8)
                    maxVisiblePages = cantidadPaginas;
            }

            $("#page-selection").bootpag({ total: cantidadPaginas, maxVisible: maxVisiblePages, page: 1 });
            // ------------------------------------------------------------------------------------------------------------------------------

            // mostramos el nombre del archivo cargado, como un mensaje de éxito al usuario ... 
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").
                                       html("Ok, el archivo '" + name + "' ha sido leído y cargado a este programa. " + 
                                            "El documento mencionado contiene " + viewModel.facturas.length.toString() + " registros.");

            // dialog box para mostrar un mensaje al usuario 
            $("#mensajeAlUsuarioDialog").dialog("open");

        };
        //reader.readAsBinaryString(f);
        //reader.readAsText(f);
        reader.readAsArrayBuffer(f);
    }
}

function getVentasPage(pageSize, pageNumber, sourceArray, targetArray) {

    // NOTA: esta función espera que el número de la página comience en 1 (no en 0) 
    targetArray.removeAll();         // nótese que el target array es en realidad un ko.observableArray 

    //$.each(result.Facturas, function (index, item) {
    //    viewModel.facturas.push(new Factura(item));
    //});

    var from = ((pageNumber - 1) * pageSize);
    var to = (pageNumber * pageSize);

    for (i = from; i < to; i++) {
        if (i > (sourceArray.length - 1)) {
            to = i;
            break;
        }

        var item = new FacturaPage(sourceArray[i]);

        // en el array están los rif de clientes que existen ... 
        // si el rif existe en el array, ponemos el item en true ... 
        var companiaYaExiste = viewModel.companiasQueExisten.some(function (data) {
            return data === item.rif(); 
        });

        if (companiaYaExiste) {
            item.existeEnContab(true);
        } else {
            item.existeEnContab(false);
        }     

        targetArray.push(item);
    }
};


$('#page-selection').bootpag({
    total: 0,
    page: 1,
    maxVisible: 1
}).on('page', function (event, num) {
    // nótese que el (bootstrap) pager regresa la página basada en 1 (y no en 0) 
    getVentasPage(16, num, viewModel.facturas, viewModel.facturasPage);
});


// -------------------------------------------------------------
// para grabar las facturas leídas desde Excel a mongodb 

function grabarAMongo() {

    // preparamos los datos que vamos a enviar al server ... 
    
    // serializamos el objeto a un string; nota: queremos recibirlo en web api como un string; no como un object 
    // luego, en c#, usamos Json.net para convertir a un objeto (es una forma; también podemos recibirlo como un 
    // objeto (type) pero preferimos hacerlo así)  

    var jsonDataAsString = JSON.stringify(viewModel.facturas);

    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/GrabarExcelDataAMongoDB";

    $.ajax({
        type: "POST",
        data: { '': jsonDataAsString },     // nótese que pasamos un objeto, para que el web api method lo pueda recibir como un value type (string) y no como json (type)
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done( function(result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        // recibimos desde el servidor, listas con catálogos para grabar compañías, facturas, etc.; las registramos en arrays en el viewmodel 

        viewModel.tiposCompania.removeAll(); 
        viewModel.monedas.removeAll();
        viewModel.cargos.removeAll();
        viewModel.formasPago.removeAll();
        viewModel.titulos.removeAll();

        result.TiposCompania.forEach(function (item, idx) {
            viewModel.tiposCompania.push({ id: item.id, descripcion: item.descripcion });
        });

        result.Monedas.forEach(function (item, idx) {
            viewModel.monedas.push({ id: item.id, descripcion: item.descripcion });
        });

        result.Cargos.forEach(function (item, idx) {
            viewModel.cargos.push({ id: item.id, descripcion: item.descripcion });
        });

        result.FormasPago.forEach(function (item, idx) {
            viewModel.formasPago.push({ id: item.id, descripcion: item.descripcion });
        });

        result.Titulos.forEach(function (item, idx) {
            viewModel.titulos.push(item.id);
        });

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

// -------------------------------------------------------------------------------------------------------------------
// para convertir el contenido del documento Excel a un json object 

fileInput.addEventListener('change', handleFile, false);

function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function (sheetName) {
        var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
        if (roa.length > 0) {
            result[sheetName] = roa;
        }
    });
    return result;
}


// -------------------------------------------------------------------------------------------------------------------
// para cada compañía en cada linea del documento Excel, y ya existiendo en mongodb, verificamos su existencia o no, 
// en la tabla de compañías 

function validarExistenciaCompanias() {

    // preparamos los datos que vamos a enviar al server ... 
    
    // serializamos el objeto a un string; nota: queremos recibirlo en web api como un string; no como un object 
    // luego, en c#, usamos Json.net para convertir a un objeto (es una forma; también podemos recibirlo como un 
    // objeto (type) pero preferimos hacerlo así)  

    var jsonDataAsString = JSON.stringify(viewModel.facturas);

    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/ValidarExistenciaCompanias";

    $.ajax({
        type: "GET",
        //data: { '': jsonDataAsString },    
        url: uri,
        contentType: 'application/x-www-form-urlencoded',
    }).done( function(result) {

        $(".mensajeAlUsuario").html("");

        if (result.ErrorFlag) {
            $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(result.ErrorMessage);
            return false;
        }

        // nótese como lo que sigue es como: !string.isnullorempty ...
        if (result.ResultMessage) {
            $(".mensajeAlUsuario").removeClass("errorMessage").addClass("infoMessage").html(result.ResultMessage);
        }

        // grabamos el rif de compañías que existen, a un array en el viewModel 
        // ésto permitirá luego, mostrar en azul/rojo, el rif de las compañías, de acuerdo a si existen o no ... 
        viewModel.companiasQueExisten.length = 0; 

        result.CompaniasQueExisten.forEach(function (item, idx) {
            viewModel.companiasQueExisten.push(item); 
        });

        // afectamos las facturas que el usuario tiene ahora en la página, para mostrar cuales existen o no
        // cada vez que el usuario página estos datos, se hace lo mismo, para mostrar los clientes que existen y los que no 

        // en el array están los rif de clientes que existen ... 
        // nótese como recorremos el ko computedArray ... 
        ko.utils.arrayForEach(viewModel.facturasPage(), function (item) {
            var companiaYaExiste = viewModel.companiasQueExisten.some(function (data) {
                return data === item.rif();
            })

            if (companiaYaExiste) {
                item.existeEnContab(true);
            } 
            else {
                item.existeEnContab(false);
            }    
        }) 

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });
}

// -------------------------------------------------------------------
// para grabar las compañías que no existen a la base de datos 

$("#catalogosCompanias").dialog({
    autoOpen: false,
    width: 850,
    modal: true,
    buttons: [
        {
            text: "Continuar ...",
            click: function () {
                grabarCompaniasQueNoExisten();
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

function grabarCompaniasQueNoExisten_openCatalogosDialog() {
    $("#catalogosCompanias").dialog("open");
}

function grabarCompaniasQueNoExisten() {

    // lo primero que hacemos es abrir un dialog, para que el usuario seleccione los catálogos 
    // que se debe usar al registrar las compañías (departamento, titulo, moneda, etc.) 

    var uriParams = "tipoCompania=" + viewModel.tiposCompaniaSeleccionado().toString() +
                    "&moneda=" + viewModel.monedaSeleccionada().toString() +
                    "&cargo=" + viewModel.cargoSeleccionado().toString() +
                    "&formaPago=" + viewModel.formasPagoSeleccionada().toString() +
                    "&titulo=" + viewModel.tituloSeleccionado().toString();

    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/GrabarCompaniasQueNoExisten?" + uriParams;

    $.ajax({
        type: "POST",
        //data: { '': jsonDataAsString },    
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
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });
}


// -------------------------------------------------------------------------------------------------------------------
// para grabar las facturas, luego de haber grabado las ocmpañías 

function grabarFacturas_openDialog() {
    $("#grabarFacturasDialog").dialog("open"); 
}

$("#grabarFacturasDialog").dialog({
    autoOpen: false,
    width: 850,
    modal: true,
    buttons: [
        {
            text: "Continuar ...",
            click: function () {
                grabarFacturas();
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

function grabarFacturas()
{
    // lo primero que hacemos es abrir un dialog, para que el usuario seleccione los catálogos 
    // que se debe usar al registrar las compañías (departamento, titulo, moneda, etc.) 

    var uriParams = "ciaContabSeleccionadaID=" + viewModel.ciaContabSeleccionada().toString() +
                    "&porcentajeImpuestosIva=" + viewModel.ivaPorc.toString() +
                    "&fechaEmisionFactura=" + viewModel.fechaFacturas().toString() +
                    "&cantidadFacturasAAgregar=" + ( viewModel.cantidadFacturasARegistrar() != null ? viewModel.cantidadFacturasARegistrar().toString(): null );

    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/GrabarFacturas?" + uriParams;

    $.ajax({
        type: "POST",
        //data: { '': jsonDataAsString },    
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

        viewModel.numeroLote(result.numeroLote);

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });
}


// -------------------------------------------------------------------------------------------------------------------
// para grabar los asientos contables, luego de haber grabado las facturas 

function grabarAsientosContables_openDialog() {
    $("#grabarAsientosDialog").dialog("open");
}

$("#grabarAsientosDialog").dialog({
    autoOpen: false,
    width: 850,
    modal: true,
    buttons: [
        {
            text: "1) Leer catálogos",
            click: function () {
                leerCatalogosAsientosContables();
            }
        },
        {
            text: "2) Grabar asientos contables",
            click: function () {
                grabarAsientosContables();
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

function leerCatalogosAsientosContables() {

    var uriParams = "ciaContabSeleccionadaID=" + viewModel.ciaContabSeleccionada().toString();
    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/LeerCatalogosGrabarAsientosContables?" + uriParams;

    $.ajax({
        type: "GET",
        //data: { '': jsonDataAsString },    
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

        // 'catálogos' necesariosp para registrar los asientos ... 
        viewModel.cuentasContables.removeAll();
        viewModel.tiposAsiento.removeAll();

        result.CuentasContables.forEach(function (item) {
            viewModel.cuentasContables.push({ cuenta: item.cuenta, descripcion: item.descripcion.toString().trim() });
        });

        result.TiposAsiento.sort().forEach(function (item) {
            viewModel.tiposAsiento.push(item);
        });

        // dialog box para mostrar un mensaje al usuario 
        $("#mensajeAlUsuarioDialog").dialog("open");
    })
    .fail(function (jqxhr, textStatus, error) {
        var errMessage = "Hemos encontrado un error al intentar ejecutar una función en el servidor, usando la dirección: <br />'" + uri + "'";
        errMessage += "<br />" + "El mensaje del error obtenido es: " + textStatus + ", " + error;
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });
}

function grabarAsientosContables() {

    var uriParams = "ciaContabSeleccionada=" + viewModel.ciaContabSeleccionada().toString() +
                "&numeroLote=" + viewModel.numeroLote() +
                "&ctaContCxCClientes_ID=" + viewModel.parametrosAgregarAsientosContables.cuentaContable_cxcClientes().toString() +
                "&ctaContIngMemb_ID=" + viewModel.parametrosAgregarAsientosContables.cuentaContable_IngMembresia().toString() +
                "&ctaContIngGrua_ID=" + viewModel.parametrosAgregarAsientosContables.cuentaContable_IngGrua().toString() +
                "&ctaContImpIva_ID=" + viewModel.parametrosAgregarAsientosContables.cuentaContable_ImpIva().toString() +
                "&factorCambio=" + viewModel.parametrosAgregarAsientosContables.factorCambio().toString() +
                "&tipoAsiento=" + viewModel.parametrosAgregarAsientosContables.tipoAsientoContable().toString();

    var uri = path + "api/ImportarCompaniasDesdeExcelWebApi/GrabarAsientosContables?" + uriParams;

    $.ajax({
        type: "POST",
        //data: { '': jsonDataAsString },    
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
        $(".mensajeAlUsuario").removeClass("infoMessage").addClass("errorMessage").html(errMessage);

        $("#filterDialog").dialog("close");
    });

}


// -------------------------------------------------------------------
// especie de dialog box para mostrar un mensaje al usuario, cada vez que 
// un proceso se completa ... 

$("#mensajeAlUsuarioDialog").dialog({
    autoOpen: false,
    width: 650,
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