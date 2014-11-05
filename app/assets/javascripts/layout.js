$(document).ready(function() {
    $('body').tooltip({ selector: '[data-toggle="tooltip"]' });

    $.validator.addMethod(
        "regex",
        function(value, element, regexp) {
            var re = new RegExp(regexp);
            return this.optional(element) || re.test(value);
        },
        "Please check your input."
    );

    $('form.validate').validate({
        showErrors: function(errorMap, errorList) {
            $.each( this.successList , function(index, value) {
                $(value).popover('hide');
            });
            $.each( errorList , function(index, value) {
                var _popover = $(value.element).popover({
                    trigger: 'manual',
                    placement: 'bottom',
                    template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>',
                    html: true
                });
                _popover.data('bs.popover').options.content = '<i class="fa fa-times"></i>' + value.message;
                $(value.element).popover('show');
            });
        }
    });

})