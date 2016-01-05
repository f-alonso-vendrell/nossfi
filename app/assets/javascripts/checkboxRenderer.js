var checkboxRenderer = function (instance, td, row, col, prop, value, cellProperties) {
        var $td = $(td);
        if (value !== 1 && value !== true)
            value = false;
        else
            value = true;

        // Center the checkbox within the cell
        $td.addClass('center');

        Handsontable.CheckboxCell.renderer.apply(this, arguments);
    }