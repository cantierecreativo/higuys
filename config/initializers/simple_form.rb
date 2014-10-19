SimpleForm.setup do |config|
  config.wrappers(
    :default,
    class: 'form__field',
    hint_class: 'has-hints',
    error_class: 'form__field--with-errors',
  ) do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :hint,  wrap_with: { tag: :p, class: 'form__field-hint' }
    b.use :error, wrap_with: { tag: :p, class: 'form__field-error' }
  end

  config.error_notification_class = 'form__alert',
  config.label_class = 'form__label',
  config.form_class = 'form',
  config.button_class = 'button--primary button--large'

  config.default_wrapper = :default
  config.boolean_style = :nested
  config.error_notification_tag = :div
  config.browser_validations = false
  config.input_class = nil
end

