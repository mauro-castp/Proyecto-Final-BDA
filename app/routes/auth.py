# routes/auth.py
from flask import Blueprint, render_template, request, session, flash, redirect, url_for, jsonify
from flask_mysqldb import MySQL

auth_bp = Blueprint('auth', __name__)

def init_auth_routes(app, mysql):
    @auth_bp.route('/login', methods=['GET', 'POST'])
    def login():
        """Página de login"""
        if 'user_id' in session:
            return redirect(url_for('index'))  # Cambiado de 'main.index' a 'index'
        
        if request.method == 'POST':
            try:
                email = request.form['email']
                password = request.form['password']
                
                cur = mysql.connection.cursor()
                cur.callproc('inicioSesion', [email, password])
                result = cur.fetchone()
                cur.close()
                
                if result:
                    session['user_id'] = result['id_usuario']
                    session['user_name'] = result['nombre']
                    session['user_role'] = result['id_rol']
                    session['user_role_name'] = result['nombre_rol']
                    session['user_email'] = result['email']
                    
                    flash(f'Bienvenido/a {session["user_name"]}', 'success')
                    return redirect(url_for('index'))  # Cambiado aquí también
                else:
                    flash('Credenciales incorrectas', 'error')
                    
            except Exception as e:
                flash(f'Error en el login: {str(e)}', 'error')
        
        return render_template('login.html')

    @auth_bp.route('/logout')
    def logout():
        """Cerrar sesión"""
        session.clear()
        flash('Sesión cerrada correctamente', 'info')
        return redirect(url_for('auth.login'))

    @auth_bp.route('/api/auth/login', methods=['POST'])
    def api_login():
        """Autenticación de usuario (API)"""
        try:
            data = request.get_json()
            email = data.get('email')
            password = data.get('password')
            
            cur = mysql.connection.cursor()
            cur.callproc('inicioSesion', [email, password])
            result = cur.fetchone()
            cur.close()
            
            if result:
                session['user_id'] = result['id_usuario']
                session['user_name'] = result['nombre']
                session['user_role'] = result['id_rol']
                session['user_role_name'] = result['nombre_rol']
                session['user_email'] = result['email']
                
                return jsonify({
                    'message': 'Login exitoso',
                    'user': {
                        'id': result['id_usuario'],
                        'name': result['nombre'],
                        'role_id': result['id_rol'],
                        'role_name': result['nombre_rol'],
                        'email': result['email']
                    }
                })
            else:
                return jsonify({'error': 'Credenciales incorrectas'}), 401
                
        except Exception as e:
            return jsonify({'error': f'Error en el login: {str(e)}'}), 500

    @auth_bp.route('/api/auth/logout', methods=['POST'])
    def api_logout():
        """Cerrar sesión (API)"""
        session.clear()
        return jsonify({'message': 'Sesión cerrada correctamente'})

    return auth_bp