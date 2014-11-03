$(document).on('click', '*[data-action]', function (e) {
    e.preventDefault();
    ajaxRecord($(this).data('action'), $(this));
})

function ajaxRecord(action, element) {
    var type = element.data('controller').substring(0, element.data('controller').length - 1);
    var title = action.charAt(0).toUpperCase() + action.slice(1) + ' ' + type.charAt(0).toUpperCase() + type.slice(1);
    $.ajax({
        url: element.attr('href'),
        type: 'GET',
        success: function (response) {
            $('.bootbox').find('form').validate();
            bootbox.dialog({
                message: response,
                title: '<i class="fa fa-plus btn-sm pull-left"></i> ' + title,
                closeButton: false,
                onEscape: function () { $(this).modal('hide'); },
                buttons: {
                    cancel: {
                        label: "Cancel",
                        className: action == 'show' ? 'hide' : 'btn-default btn-lg pull-left',
                        callback: function () { $(this).modal('hide'); }
                    },
                    save: {
                        label: action == 'show' ? 'Done' : 'Save',
                        className: "btn-primary btn-lg",
                        callback: function () {
                            if (action == 'show') {
                                $(this).modal('hide');
                            } else {
                                $('.bootbox').find('div.ajax_form .alert').remove();
                                var form = $('.bootbox').find('form.validate');
                                if (form.valid()) {
                                    $('[data-bb-handler="save"]').html('<i class="fa fa-refresh fa-spin"></i>');
                                    $.ajax({
                                        url: form.attr('action'),
                                        type: 'POST',
                                        data: form.serialize(),
                                        success: function (response) {
                                            window.location.reload(true);
                                        },
                                        error: function (response) {
                                            var div = $('<div/>').addClass('alert alert-danger').append($('<h4/>').text('This ' + type + ' could not be saved'));
                                            var ul = $('<ul/>');
                                            switch (response.status) {
                                                case 422 :
                                                    // show rails model validation message(s)
                                                    $.each(response.responseJSON.errors, function (idx, error) {
                                                        ul.append($('<li/>').text(error));
                                                    })
                                                    break;
                                                default :
                                                    // show generic HTTP response error message
                                                    ul.append($('<li/>').text(response.responseText));
                                            }
                                            $('.bootbox').find('div.ajax_form').prepend(div.append(ul));
                                            $('[data-bb-handler="save"]').text('Save');
                                        }
                                    })
                                }
                                return false;
                            }
                        }
                    }
                }
            });
        }
    })
}