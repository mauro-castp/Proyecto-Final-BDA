# utils/decorators.py
from functools import wraps
from flask import session, request, redirect, url_for, flash, jsonify

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            if request.path.startswith('/api/'):
                return jsonify({'error': 'No autenticado'}), 401
            flash('Debe iniciar sesión', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

def role_required(roles):
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if 'user_id' not in session:
                if request.path.startswith('/api/'):
                    return jsonify({'error': 'No autenticado'}), 401
                flash('Debe iniciar sesión', 'error')
                return redirect(url_for('login'))
                
            if session['user_role'] not in roles:
                if request.path.startswith('/api/'):
                    return jsonify({'error': 'Permisos insuficientes'}), 403
                flash('No tiene permisos para esta acción', 'error')
                return redirect(url_for('index'))
            return f(*args, **kwargs)
        return decorated_function
    return decorator