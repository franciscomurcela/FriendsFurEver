from flask import Flask, render_template, session, request, redirect, url_for, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
import hashlib
import pyodbc as odbc
DRIVER_NAME='SQL Server'
SERVER_NAME='mednat.ieeta.pt\SQLSERVER,8101'
DATABASE_NAME='p10g2'

session={}
session['Autenticated']=False
# DATABASE CONNECTION
connection_string = f"""
    Driver={{{DRIVER_NAME}}};
    Server={SERVER_NAME};
    Database={DATABASE_NAME};
    Trust_Connection=yes;
    uid=p10g2;
    pwd=BDg2fixe;
    """ 
conn= odbc.connect(connection_string)
print(conn)
cursor = conn.cursor()

app = Flask(__name__)





# HOME

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/home')
def redirect_home():
    return render_template('home.html')







# HOME EMPREGADO

@app.route('/homeempregado')
def homeempregado():
    return render_template('homeempregado.html')

@app.route('/stats', methods=['GET'])
def stats():
    try:
        cursor = conn.cursor()

        cursor.execute("SELECT dbo.GetTotalPetsInShelter()")
        total_pets = cursor.fetchone()[0]

        cursor.execute("SELECT dbo.TotalAdoptedPetsInShelter()")
        total_adopted_pets = cursor.fetchone()[0]

        cursor.execute("SELECT dbo.TotalEmployeesInShelter()")
        total_employees = cursor.fetchone()[0]

        cursor.execute("SELECT dbo.PercentageAdoptedPetsInShelter()")
        percentage_adopted_pets = cursor.fetchone()[0]

        cursor.execute("SELECT dbo.MostCommonPetBreedInShelter()")
        most_common_breed = cursor.fetchone()[0]

        return jsonify({
            'totalPets': total_pets,
            'totalAdoptedPets': total_adopted_pets,
            'totalEmployees': total_employees,
            'percentageAdoptedPets': percentage_adopted_pets,
            'mostCommonBreed': most_common_breed
        })
    except Exception as e:
        print(str(e))
        return jsonify({'error': str(e)}), 500








# ANIMAIS

@app.route('/animais')
def animais():
    return render_template('animais.html')

@app.route('/animais', methods=['POST'])
def animais_post():
    filter = request.form['filter']
    page = int(request.form['page']) if 'page' in request.form else 1
    records_per_page = int(request.form['recordsPerPage']) if 'recordsPerPage' in request.form else 8
    offset = (page - 1) * records_per_page

    if filter == "option1":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option2":
        sql = """
        SELECT Nome, img FROM (
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option3":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'f'
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'f'
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option4":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE pet.Sexo = 'm'
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE pet.Sexo = 'm'
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option5":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade < 4
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade < 4
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option6":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade BETWEEN 4 AND 7
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade BETWEEN 4 AND 7
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    elif filter == "option7":
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog WHERE dog.idade > 7
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat WHERE cat.idade > 7
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    else:
        sql = """
        SELECT Nome, img FROM (
            SELECT dog.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN dog ON pet.Id = dog.IdDog
            UNION
            SELECT cat.Nome, pet.img, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as row_num
            FROM pet JOIN cat ON pet.Id = cat.IdCat
        ) t
        WHERE t.row_num BETWEEN ? AND ?
        """
    cursor = conn.cursor()
    cursor.execute(sql, (offset + 1, offset + records_per_page - 1))  # Adjusted this line
    pets = cursor.fetchall()
    pets_dict = [{'Nome': row[0], 'img': row[1]} for row in pets]
    return jsonify(pets_dict)







# ANIMAIS EMPREGADO

@app.route('/animaisempregado')
def animaisempregado():
    return render_template('animaisempregado.html')

@app.route('/animaisempregado', methods=['POST'])
def animaisempregado_post():
    sql = """
    SELECT dog.Nome, pet.img FROM pet JOIN dog ON pet.Id = dog.IdDog
    UNION
    SELECT cat.Nome, pet.img FROM pet JOIN cat ON pet.Id = cat.IdCat
    """

    cursor = conn.cursor()
    cursor.execute(sql)
    pets = cursor.fetchall()
    pets_dict = [{'Nome': row[0], 'img': row[1]} for row in pets]

    return jsonify(pets_dict)








# ADD ANIMAL

@app.route('/addanimal')
def addanimal():
    return render_template('addanimal.html')

@app.route('/addanimal', methods=['POST'])
def addanimal_post():
    nome = request.form['nome']
    id = request.form['Id']
    raca = request.form['raca']
    sexo = request.form['sexo']
    estadoAdocao = 1 if 'estadoAdocao' in request.form else 0
    microchip = 1 if 'microchip' in request.form else 0
    tipo = 1 if 'tipo' in request.form else 0
    Healthy = 1 if 'Healthy' in request.form else 0
    idade = request.form['idade']
    idmae = request.form['idMae'] if 'idMae' in request.form and request.form['idMae'] != '' else None
    idpai = request.form['idPai'] if 'idPai' in request.form and request.form['idPai'] != '' else None
    img = request.form['img']
    comportamento = request.form['comportamento']

    cursor = conn.cursor()

    if idmae is not None:
        cursor.execute("SELECT Id FROM pet WHERE Id = ?", (idmae,))
        result = cursor.fetchone()
        if not result:
            return 'IdMae does not exist in the pet table.', 400

    cursor.execute("INSERT INTO pet(Id,EstadoDeAdocao, microchip, comportamento, IdMae, IdPai, Healthy, sexo, img) VALUES (?,?, ?, ?, ?, ?, ?, ?, ?)", (id,estadoAdocao, microchip, comportamento, idmae, idpai, Healthy, sexo, img))
    idPet = id

    if tipo == 1:
        cursor.execute("INSERT INTO dog(IdDog, nome, raca, idade) VALUES (?, ?, ?, ?)", (idPet, nome, raca, idade))
    else:
        cursor.execute("INSERT INTO cat(IdCat, nome, raca, idade) VALUES (?, ?, ?, ?)", (idPet, nome, raca, idade))

    conn.commit()

    return redirect(url_for('animaisempregado'))








# MANAGE ANIMAL

@app.route('/manageanimal')
def manageanimal():
    return render_template('manageanimal.html')

@app.route('/editanimalupdate', methods=['POST'])
def editanimalupdate():
    cursor = conn.cursor()

    id = request.form['Id']
    sexo = request.form['Sexo']
    estadoAdocao = request.form['EstadoDeAdocao']
    comportamento = request.form['Comportamento']
    microchip = request.form['Microchip']
    img = request.form['Img']
    healthy = request.form['Healthy']
    idmae = request.form['IdMae'] if 'IdMae' in request.form else None
    idpai = request.form['IdPai'] if 'IdPai' in request.form else None
    nome = request.form['Nome']
    raca = request.form['Raca']
    idade = request.form['Idade']

    # Check if idmae exists in the pet table
    cursor.execute("SELECT Id FROM pet WHERE Id = ?", (idmae,))
    if not cursor.fetchone():
        idmae = None  # Set idmae to None if it doesn't exist in the pet table

    # Check if idpai exists in the pet table
    cursor.execute("SELECT Id FROM pet WHERE Id = ?", (idpai,))
    if not cursor.fetchone():
        idpai = None  # Set idpai to None if it doesn't exist in the pet table

    # Now execute the UPDATE statement
    cursor.execute("UPDATE pet SET Sexo = ?, EstadoDeAdocao = ?, Comportamento = ?, Microchip = ?, Img = ?, Healthy = ?, IdMae = ?, IdPai = ? WHERE Id = ?", (sexo, estadoAdocao, comportamento, microchip, img, healthy, idmae, idpai, id))

    cursor.execute("SELECT * FROM dog WHERE IdDog = ?", id)
    if cursor.fetchone():
        cursor.execute("UPDATE dog SET Nome = ?, Raca = ?, Idade = ? WHERE IdDog = ?", (nome, raca, idade, id))
    else:
        cursor.execute("UPDATE cat SET Nome = ?, Raca = ?, Idade = ? WHERE IdCat = ?", (nome, raca, idade, id))

    conn.commit()

    return redirect(url_for('manageanimal'))






# ADOTAR
def row2dict(row, cursor):
    return {desc[0]: value for desc, value in zip(cursor.description, row)}

# Data fetching route
@app.route('/api_adotar', methods=['GET', 'POST'])
def api_adotar():
    cursor = conn.cursor()
    nome = request.args.get('nome')
    cursor.execute("""
        SELECT pet.*, COALESCE(dog.Nome, cat.Nome) as Nome, COALESCE(dog.Raca, cat.Raca) as Raca, COALESCE(dog.Idade, cat.Idade) as Idade
        FROM pet 
        LEFT JOIN dog ON pet.Id = dog.IdDog 
        LEFT JOIN cat ON pet.Id = cat.IdCat 
        WHERE COALESCE(dog.Nome, cat.Nome) = ?
    """, (nome,))
    pet = cursor.fetchone()
    return jsonify(row2dict(pet, cursor))

# HTML rendering route
@app.route('/adotar', methods=['GET', 'POST'])
def adotar():
    return render_template('adotar.html')



# ADOTAR MENU

@app.route('/adotarmenu')
def adotarmenu():
    return render_template('adotarmenu.html')

@app.route('/adotarmenu', methods=['POST'])
def adotarmenu_post():
    cc = request.form['cc']
    id = request.form['Id']

    cursor = conn.cursor()
    cursor.execute("SELECT * FROM utilizador, adotante WHERE utilizador.CC = ? AND adotante.CC = ?", (cc, cc))
    user = cursor.fetchone()

    all_columns_filled = all(value is not None for value in user.values())

    if all_columns_filled:
        cursor.execute("INSERT INTO adocoes (IdPet, CCAdotante, EstadoAdocaoPet) VALUES (?, ?, 1)", (id, cc))
        cursor.execute("UPDATE pet SET EstadoDeAdocao = 1 WHERE Id = ?", (id,))
        conn.commit()
        return 'Adoption request submitted successfully.', 200
    else:
        return 'Please fill all the columns in the form.', 400








# AGRADECIMENTO

@app.route('/agradecimento')
def agradecimento():
    return render_template('agradecimento.html')








# SETTINGS

@app.route('/settings')
def settings():
    return render_template('settings.html')

@app.route('/settings', methods=['POST'])
def settings_post():
    cc = request.form['cc']
    nome = request.form['nome']
    morada = request.form['morada']
    contacto = request.form['contacto']
    idade = request.form['idade']
    emprego = request.form['emprego']
    email = request.form['email']

    cursor = conn.cursor()
    cursor.execute("SELECT cc FROM utilizador WHERE cc = ?", (cc,))
    result = cursor.fetchone()

    if result:
        cursor.execute("UPDATE utilizador SET nome = ?, morada = ?, contacto = ?, email = ? WHERE cc = ?", (nome, morada, contacto, email, cc))
        conn.commit()
        cursor.execute("SELECT CC FROM adotante WHERE CC = ?", (cc,))
        result = cursor.fetchone()

        if result:
            cursor.execute("UPDATE adotante SET idade = ?, emprego = ? WHERE CC = ?", (idade, emprego, cc))
        else:
            cursor.execute("INSERT INTO adotante(idade, emprego, CC) VALUES (?, ?, ?)", (idade, emprego, cc))

        conn.commit()
        return redirect(url_for('home'))
    else:
        return 'CC does not exist in the utilizador table.', 400








# SETTINGS EMPREGADO

@app.route('/settingsempregado')
def settingsempregado():
    return render_template('settingsempregado.html')

@app.route('/tratamentos' , methods=['GET'])
def tratamentos():
    return render_template('tratamentos.html')

@app.route('/tratamentos_api', methods=['POST'])
def tratamentos_api():
    cursor = conn.cursor()

    id = request.form['Id']
    leishmaniose = request.form['Leishmaniose']
    gripe = request.form['Gripe']
    raiva = request.form['Raiva']
    desparasitado = request.form['Desparasitado']
    esterilizado = request.form['Esterilizado']

    cursor.execute("SELECT * FROM vacinas WHERE IdPet_Pet = ?", id)
    vacinas_exists = cursor.fetchone()

    if vacinas_exists:
        cursor.execute("UPDATE vacinas SET Leishmaniose = ?, Gripe = ?, Raiva = ? WHERE IdPet_Pet = ?", (leishmaniose, gripe, raiva, id))
    else:
        cursor.execute("INSERT INTO vacinas (IdPet_Pet, Leishmaniose, Gripe, Raiva) VALUES (?, ?, ?, ?)", (id, leishmaniose, gripe, raiva))

    cursor.execute("SELECT * FROM tratamentos WHERE IdPet_Pet_Pet = ?", id)
    tratamentos_exists = cursor.fetchone()

    if tratamentos_exists:
        cursor.execute("UPDATE tratamentos SET Desparasitado = ?, Esterilizado = ? WHERE IdPet_Pet_Pet = ?", (desparasitado, esterilizado, id))
    else:
        cursor.execute("INSERT INTO tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado) VALUES (?, ?, ?)", (id, desparasitado, esterilizado))

    conn.commit()

    return jsonify({'message': 'Data updated successfully'})








# LOGIN

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login_post():
    cc = request.form['cc']
    password = request.form['password']

    # Hash the password using SHA256
    hashed_password = hashlib.sha256(password.encode()).hexdigest()

    cursor = conn.cursor()
    cursor.execute("SELECT Pass FROM utilizador WHERE cc = ?", (cc,))
    result = cursor.fetchone()

    if result and result[0] == hashed_password:
        return redirect(url_for('home'))







# EMPREGADO LOGIN

@app.route('/empregadologin')
def empregadologin():
    return render_template('empregadologin.html')

@app.route('/empregadologin', methods=['POST'])
def empregadologin_post():
    idtrabalho = request.form['idtrabalho']
    password = request.form['password']

    # Hash the password using SHA256
    hashed_password = hashlib.sha256(password.encode()).hexdigest()

    cursor = conn.cursor()
    cursor.execute("SELECT u.Pass FROM utilizador u INNER JOIN empregado e ON u.cc = e.cc WHERE e.idtrabalho = ?", (idtrabalho,))
    result = cursor.fetchone()

    if result and result[0] == hashed_password:
        return redirect(url_for('homeempregado'))
    else:
        return 'Invalid credentials', 401







# EMPREGADO REGISTER

@app.route('/empregadoregister')
def empregadoregister():
    return render_template('empregadoregister.html')

@app.route('/empregadoregister', methods=['POST'])
def empregadoregister_post():
    idtrabalho = request.form['idtrabalho']
    cc = request.form['cc']
    password = request.form['password']
    passwordvalidate = request.form['passwordvalidate']

    if password != passwordvalidate:
        return 'Passwords do not match.', 400

    hashed_password = hashlib.sha256(password.encode()).hexdigest()


    cursor = conn.cursor()
    cursor.execute("INSERT INTO utilizador(cc, Pass) VALUES (?, ?)", (cc, hashed_password))
    cursor.execute("INSERT INTO empregado(idtrabalho, cc) VALUES (?, ?)", (idtrabalho, cc))
    conn.commit()

    return redirect(url_for('empregadologin'))









# REGISTER

@app.route('/register', methods=['GET'])
def register():
    return render_template('register.html')

@app.route('/register', methods=['POST'])
def register_post():
    cc = request.form['cc']
    password = request.form['password']
    passwordvalidate = request.form['passwordvalidate']

    if password != passwordvalidate:
        # Handle the case where the passwords do not match
        return 'Passwords do not match.', 400

    hashed_password = hashlib.sha256(password.encode()).hexdigest()
    # Truncate the hash to 99 characters to fit Password column in the database


    cursor = conn.cursor()
    cursor.execute("INSERT INTO utilizador(cc, Pass) VALUES (?, ?)", (cc, hashed_password))
    conn.commit()

    # After successful registration, redirect the user to the home page
    return redirect(url_for('login'))










# SEARCH

@app.route('/search', methods=['POST'])
def search_post():
    query = request.form['query']

    try:
        sql = """
        SELECT utilizador.Nome AS NomeUser, utilizador.CC, adocoes.idPet, COALESCE(cat.Nome, dog.Nome) AS NomePet
        FROM utilizador 
        JOIN adocoes ON utilizador.CC = adocoes.CCAdotante 
        LEFT JOIN cat ON adocoes.idPet = cat.idCat 
        LEFT JOIN dog ON adocoes.idPet = dog.idDog 
        WHERE utilizador.Nome LIKE ? OR utilizador.CC LIKE ?
        """
        param = "%" + query + "%"
        cursor.execute(sql, (param, param))
        users = [dict(zip([column[0] for column in cursor.description], row)) for row in cursor.fetchall()]
        return jsonify(users)

    except Exception as e:
        print(e)
        return 'Error', 400
    








# EDIT ANIMAL GET

@app.route('/editanimalget', methods=['GET'])
def editanimalget():
    nome = request.args.get('nome')

    sql = """
    SELECT pet.*, COALESCE(dog.Nome, cat.Nome) as Nome, COALESCE(dog.Raca, cat.Raca) as Raca, COALESCE(dog.Idade, cat.Idade) as Idade, 
    vacinas.Leishmaniose, vacinas.Gripe, vacinas.Raiva, tratamentos.Desparasitado, tratamentos.Esterilizado
    FROM pet 
    LEFT JOIN dog ON pet.Id = dog.IdDog 
    LEFT JOIN cat ON pet.Id = cat.IdCat 
    LEFT JOIN vacinas ON pet.Id = vacinas.IdPet_Pet
    LEFT JOIN tratamentos ON pet.Id = tratamentos.IdPet_Pet_Pet
    WHERE COALESCE(dog.Nome, cat.Nome) = ?
    """

    cursor.execute(sql, nome)
    pet = cursor.fetchone()
    pet_dict = dict(zip([column[0] for column in cursor.description], pet))

    return jsonify(pet_dict)



# REMOVE ANIMAL

@app.route('/removeanimal', methods=['POST'])
def removeanimal():
    petId = request.form.get('id')

    try:
        cursor.execute("DELETE FROM dog WHERE IdDog = ?", petId)
        cursor.execute("DELETE FROM cat WHERE IdCat = ?", petId)
        cursor.execute("DELETE FROM pet WHERE Id = ?", petId)
        conn.commit()

        return jsonify({'status': 'success'}), 200
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)}), 500
    






if __name__ == '__main__':
    app.run(debug=True)