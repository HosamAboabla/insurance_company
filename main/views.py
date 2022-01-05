from flask import Flask , render_template , redirect , url_for , request
from forms import CustomerCreationForm , AddDependantForm , HospitalCreationForm , HospitalAssociatePlanForm , PurchasedPlansForm , FileInsuranceClaimForm
# from settings import db
from flask_mysqldb import MySQL
from database_secrets import HOST , USER , DATABASE , PASSWORD


app = Flask(__name__)

app.config['MYSQL_USER'] = USER
app.config['MYSQL_PASSWORD'] = PASSWORD
app.config['MYSQL_HOST'] = HOST
app.config['MYSQL_DB'] = DATABASE
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

mysql = MySQL(app)


def excute_command(query):
    cur = mysql.connection.cursor()
    cur.execute(query)
    mysql.connection.commit()


def fetech_data(query):
    cur = mysql.connection.cursor()
    cur.execute(query)
    mysql.connection.commit()


@app.route("/")
@app.route("/<name>")
def index(name="John Doe"):
    template_name = "base.html" 
    context = {
        "name":name,
    }
    return render_template(template_name , context=context)


@app.route("/table")
def table():
    template_name = "basic-table.html" 
    context = {
        
    }
    return render_template(template_name , context=context)

@app.route("/dashboard")
def dashboard():
    template_name = "dashboard.html" 
    context = {
        
    }
    return render_template(template_name , context=context)


@app.route("/profile")
def profile():
    template_name = "profile.html" 
    context = {
        
    }
    return render_template(template_name , context=context)


@app.route("/customer_create" , methods = ['GET' , 'POST'])
def CustomerCreationView():
    template_name = "create.html" 
    form = CustomerCreationForm(request.form)
    cur = mysql.connection.cursor()
    
    if request.method == 'POST' and form.validate():
        name =  form.name.data
        phone_number = form.phone_number.data
        address = form.address.data
        
        # query = "insert into customers values (%d , %s , %s  , %s , %s , %s);" , None , last_name , phone_number , address , None
        # query = f"insert into customers VALUES ('{None}' , '{first_name}' , '{last_name}'  , '{phone_number}' , '{address}' , '{None}');"
        # query = ''' 
        #     insert into 
        #     customers (`id` , `first_name` , `last_name` , `phone_number` , `address` , `benefits`) 
        #     VALUES (%s , %s , %s  , %s , %s , %s)''',(None , first_name , last_name , phone_number , address , None)
        cur.execute(''' 
            insert into 
            customer (`id` , `name` , `phone_number` , `address` , `benplan_id`) 
            VALUES (%s , %s ,  %s , %s , %s)''',(None , name , phone_number , address , None))
        # records = db(query)
        mysql.connection.commit()

        return redirect(url_for('table'))
    context = {
        
    }
    return render_template(template_name , context=context , form = form)

@app.route("/customer_list" , methods = ['GET'])
def CustomerListView():
    template_name = "customers_list.html" 
    cur = mysql.connection.cursor()
    
    cur.execute(''' SELECT * FROM list_of_customers ''')
    customers = cur.fetchall()
    print(customers)
    context = {
        "customers": customers,
    }
    return render_template(template_name , context=context)


# -------------------------------- Customer purchase plan --------------------------------
@app.route("/purhase_plan/<id>", methods = ['GET' , 'POST'])
def PurchasedPlansView(id):
    template_name = "create.html" 
    form = PurchasedPlansForm(request.form)
    
    cur = mysql.connection.cursor()
    if request.method == 'POST':# and form.validate():
        plans_type_id = form.ptype_id.data
        benefit_id =  form.benefits_id.data

        me_check = 'me_'

        if plans_type_id and benefit_id:
            cur.execute(''' 
                INSERT INTO purchased_plans 
                (id , customer_id , ptype_id)
                VALUES(%s , %s , %s);''',(None , id , plans_type_id))
            mysql.connection.commit()

            cur.execute('''SELECT LAST_INSERT_ID();''')
            purchased_plan = cur.fetchall()[0]['LAST_INSERT_ID()']

            if me_check in benefit_id:
                cur.execute(''' call add_customer_benefits(%s , %s);''' , (id , purchased_plan))
            else:
                cur.execute(''' call add_dependant_benefits(%s , %s);''' , (benefit_id , purchased_plan))
            mysql.connection.commit()


        return redirect(url_for('table'))

    else:
        cur.execute(''' call dependants_of_customer(%s);''' , (id))
        
        benefits = cur.fetchall()
        
        cur.execute(''' SELECT * FROM list_of_plan_types ''')
        plans_types = cur.fetchall()

        cur.execute(''' call  get_customer_benefits(%s); ''' , (id))
        customer_benefits = cur.fetchall()[0]['benplan_id']


        choices_plan_types = [ (plans_type['id'] , f"{plans_type['type']}") for plans_type in plans_types ]
        choices_benefits = [ (benefit['id'] , f"{benefit['name']}") for benefit in benefits ]

        if customer_benefits is None:
            choices_benefits.insert(0 , (f"me_{id}" , "Me"))
        form.ptype_id.choices = choices_plan_types
        form.benefits_id.choices = choices_benefits

    context = {
        
    }
    return render_template(template_name , context=context , form = form)



# -------------------------------- Customer file insurance claim --------------------------------
@app.route("/file_insurance_claim/<id>", methods = ['GET' , 'POST'])
def FileInsuranceClaimView(id):
    template_name = "create.html" 
    form = FileInsuranceClaimForm(request.form)
    
    cur = mysql.connection.cursor()
    if request.method == 'POST':# and form.validate():
        expenses_amout = form.expense_amount.data
        expense_details =  form.expense_details.data
        insurance_data = str(form.insurance_date.data)
        plan_id = form.plan_id.data
        resolved = False

        print(form.data)
    

        if expenses_amout and expense_details and insurance_data and plan_id:
            cur.execute(''' 
                call file_insurance_claim
                (%s , %s , %s , %s , %s , %s);''',( expenses_amout , expense_details , insurance_data , id , plan_id , resolved))
            mysql.connection.commit()
 
        return redirect(url_for('table'))

    else:

        
        cur.execute(''' call customer_purchased_plans(%s) ''',(id))
        purchased_plans = cur.fetchall()


        choices_purchased_plans = [ (purchased_plan['id'] , f"{purchased_plan['id']} - {purchased_plan['name']}") for purchased_plan in purchased_plans ]

        form.plan_id.choices =choices_purchased_plans

    context = {
        
    }
    return render_template(template_name , context=context , form = form)



# -------------------------------- Customer file insurance claim --------------------------------
@app.route("/insurance_claim_list" , methods = ['GET' , 'POST'])
def InsuranceClaimListView():
    template_name = "insurance_list.html" 
    cur = mysql.connection.cursor()

    if request.method == 'POST':
        resolve = request.form.getlist("resolve")

        for claim_id in resolve:
            cur.execute('''call mark_as_resolved(%s); ''', str(claim_id))
            mysql.connection.commit()
            

        return redirect(url_for('table'))
    else:

        resolved_check = request.args.get("resolved")
        if resolved_check == 'false':
            cur.execute(''' SELECT * FROM insurance_claim where resolved= %s''' , str(0))
        else:
            cur.execute(''' SELECT * FROM insurance_claim ''')
        insurance_claims = cur.fetchall()
        
        for insurance_claim in insurance_claims:
            cur.execute('''call get_customer_name(%s); ''', str(insurance_claim['customer_id']))
            customer_name = cur.fetchall()[0]['name']

            cur.execute('''call get_plan_beneficary(%s); ''', str(insurance_claim['plan_id']))
            beneficary_name = cur.fetchall()[0]['name']
            insurance_claim["customer_name"] = customer_name
            insurance_claim["beneficary_name"] = beneficary_name


    
    context = {
        "insurance_claims": insurance_claims,
    }
    return render_template(template_name , context=context)



@app.route("/hospital_create" , methods = ['GET' , 'POST'])
def HospitalCreationView():
    template_name = "create.html" 
    form = HospitalCreationForm(request.form)
    
    cur = mysql.connection.cursor()
    if request.method == 'POST' and form.validate():
        name =  form.name.data
        address = form.address.data
        
        print(form.data)

        cur.execute(''' 
            insert into 
            hospital (`id` , `name` , `address`) 
            VALUES (%s , %s , %s)''',(None , name , address))
        # records = db(query)
        mysql.connection.commit()

        return redirect(url_for('table'))
    context = {
        
    }
    return render_template(template_name , context=context , form = form)


@app.route("/add_dependant" , methods = ['GET' , 'POST'])
def AddDependantView():
    template_name = "create.html" 
    form = AddDependantForm(request.form)
    
    cur = mysql.connection.cursor()
    if request.method == 'POST':# and form.validate():
        customer_id = form.customer_id.data
        name =  form.name.data
        relationship =  form.relationship.data
        birthdate =  str(form.birthdate.data) # .strftime('%Y-%m-%d') #  %H:%M:%S
        # benefits = form.benefits.data

        if name  and relationship and birthdate and customer_id != "None":
            cur.execute(''' 
                insert into 
                dependant (`id` , `name`  , `customer_id` , `benplan_id` , `relationship` , `birthdate` ) 
                VALUES (%s , %s , %s  , %s , %s , %s)''',(None , name  , customer_id , None , relationship , birthdate))
            mysql.connection.commit()

        return redirect(url_for('table'))

    else:
        cur.execute(''' SELECT * FROM customer ''')
        customers = cur.fetchall()
        choices = [ (customer['id'] , f"{customer['name']}") for customer in customers ]
        choices.insert(0 , (None , "-----"))
        # form.customer_id.default = (None , "-----")
        form.customer_id.choices = choices
        
    context = {
        
    }
    return render_template(template_name , context=context , form = form)



@app.route("/hospital_associate_plan" , methods = ['GET' , 'POST'])
def HospitalAssociatePlanView():
    template_name = "create.html" 
    form = HospitalAssociatePlanForm(request.form)
    
    cur = mysql.connection.cursor()
    if request.method == 'POST':# and form.validate():
        plans_ids = form.plan_id.data
        hospital_id =  form.Hosp_id.data

        if plans_ids  and hospital_id:
            for plan_id in plans_ids:
                cur.execute(''' 
                    insert into 
                    has (`plan_id` , `Hosp_id` ) 
                    VALUES (%s , %s )''',(plan_id , hospital_id))
                mysql.connection.commit()

        return redirect(url_for('table'))

    else:
        cur.execute(''' SELECT * FROM plan_type ''')
        plans_types = cur.fetchall()

        cur.execute(''' SELECT * FROM hospital ''')
        hospitals = cur.fetchall()

        choices_plan_types = [ (plans_type['id'] , f"{plans_type['type']}") for plans_type in plans_types ]
        choices_hospitals = [ (hospital['id'] , f"{hospital['name']}") for hospital in hospitals ]

        # user = User.query.get(id)
        # form = UserDetails(request.POST, obj=user)
        # form.customer_id.default = (None , "-----")
        form.plan_id.choices = choices_plan_types
        form.Hosp_id.choices = choices_hospitals

    context = {
        
    }
    return render_template(template_name , context=context , form = form)







if __name__ == '__main__':
    app.run(debug=True)