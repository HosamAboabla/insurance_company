from wtforms import Form, BooleanField, StringField, PasswordField, validators , SelectField , DateField , SelectMultipleField
from wtforms.fields.numeric import IntegerField


class CustomerCreationForm(Form):
    name      = StringField('Name', [validators.Length(max=50) , validators.DataRequired()])
    phone_number    = StringField('Phone number', [validators.Length(min=11, max=11)])
    address         = StringField('Address' , [validators.Length(max=255) , validators.DataRequired()])



class HospitalCreationForm(Form):
    name      = StringField('Name', [validators.Length(max=50) , validators.DataRequired()])
    address         = StringField('Address' , [validators.Length(max=255) , validators.DataRequired()])



class HospitalAssociatePlanForm(Form):
    plan_id         = SelectMultipleField(u'Plan', coerce=str)
    Hosp_id         = SelectField(u'Hospital', coerce=str)

class AddDependantForm(Form):
    customer_id          = SelectField(u'Customer', coerce=str)
    name                 = StringField('Name', [validators.Length(max=50) , validators.DataRequired()])
    relationship         = StringField('Relationship',  [validators.Length(max=50) , validators.DataRequired()])
    birthdate            = DateField('Birthdate',  [validators.DataRequired()])
    # benefits        = StringField('Address' , [validators.Length(max=255) , validators.DataRequired()])


class PurchasedPlansForm(Form):
    ptype_id                 = SelectField(u'Name' , coerce=str)
    benefits_id              = SelectField(u'Beneficiary', coerce=str)
    # dependant = BooleanField(label="Dependant")