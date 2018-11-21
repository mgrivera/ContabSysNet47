
ko.bindingHandlers.currency = {
    symbol: ko.observable('$'),
    update: function (element, valueAccessor, allBindingsAccessor) {
        return ko.bindingHandlers.text.update(element, function () {
            var value = +(ko.utils.unwrapObservable(valueAccessor()) || 0)
            var symbol = ko.utils.unwrapObservable(allBindingsAccessor().symbol != undefined ? allBindingsAccessor().symbol : ko.bindingHandlers.currency.symbol);
            return symbol + value.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
        });
    }
};


// currency formatted, but no symbol used ... 
ko.bindingHandlers.currencyNoSimbol = {
    //symbol: ko.observable('$'),
    update: function (element, valueAccessor, allBindingsAccessor) {
        return ko.bindingHandlers.text.update(element, function () {
            var value = +(ko.utils.unwrapObservable(valueAccessor()) || 0)
            //var symbol = ko.utils.unwrapObservable(allBindingsAccessor().symbol != undefined ? allBindingsAccessor().symbol : ko.bindingHandlers.currency.symbol);
            return value.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");
        });
    }
};

// currency formatted, but no symbol and spanish locale (ie: 1000.75 -> 1.000,75)  ... 
ko.bindingHandlers.currencyNoSimbolSpanish = {
    //symbol: ko.observable('$'),
    update: function (element, valueAccessor, allBindingsAccessor) {
        return ko.bindingHandlers.text.update(element, function () {
            var value = +(ko.utils.unwrapObservable(valueAccessor()) || 0)
            //var symbol = ko.utils.unwrapObservable(allBindingsAccessor().symbol != undefined ? allBindingsAccessor().symbol : ko.bindingHandlers.currency.symbol);
            value = value.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,");

            value = value.replace(",", "|");
            value = value.replace(".", ",");
            value = value.replace("|", ".");

            return value; 
        });
    }
};




// this is to format ko values, but independently of their use: display only or editable ... 
(function () {

    var toMoney = function (num) {
        return '$' + (num.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
    };

    var handler = function (element, valueAccessor, allBindings) {
        var $el = $(element);
        var method;

        // Gives us the real value if it is a computed observable or not
        var valueUnwrapped = ko.unwrap(valueAccessor());

        if ($el.is(':input')) {
            method = 'val';
        } else {
            method = 'text';
        }
        return $el[method](toMoney(valueUnwrapped));
    };

    ko.bindingHandlers.money = {
        update: handler
    };
})();