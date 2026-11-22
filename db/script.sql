USE construplan;


CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol ENUM('EMPLEADO','CAMPO','OFICINA','ADMIN') DEFAULT 'EMPLEADO',
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuario (username, password, rol, activo)
VALUES ('admin', 'contr@seña', 'ADMIN', TRUE);


CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    dni CHAR(8) NOT NULL UNIQUE,
    categoria VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(9),
    fecha_nacimiento DATE, 
    banco VARCHAR(30),
    cuenta_bancaria VARCHAR(30),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE sueldo (
	id_sueldo INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL ,
    fecha_inicio DATE,
    fecha_fin DATE,
    sueldo DECIMAL(10,2),
    periodo ENUM('SEMANAL','MENSUAL','DIARIO') DEFAULT 'SEMANAL',
	FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);
    
CREATE TABLE proyecto (
    id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tarea (
    id_tarea INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100),
    unidad_medida VARCHAR(20) NOT NULL -- m2, ml, unidades, etc
);

CREATE TABLE meta (
    id_meta INT AUTO_INCREMENT PRIMARY KEY,
    id_tarea INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    horas_equivalentes DECIMAL(4,2) NOT NULL,
    es_libre BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_tarea) REFERENCES tarea(id_tarea)
);

CREATE TABLE asignacion_tarea (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_asignador INT NOT NULL,
    id_proyecto INT NOT NULL,    
    id_meta INT NOT NULL,
    modalidad            ENUM('JORNAL','TAREA') NOT NULL DEFAULT 'JORNAL',
    hora_meta_completada TIME NULL,
    fecha DATE NOT NULL,
    
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto(id_proyecto),
    FOREIGN KEY (id_meta) REFERENCES meta(id_meta)
);



CREATE TABLE registro_diario (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_asignacion INT NOT NULL,
    hora_inicio TIME,
    hora_fin TIME,
    produccion_real DECIMAL(10,2),
    horas_base DECIMAL(4,2),
    horas_extra DECIMAL(4,2),
    estado ENUM('PENDIENTE','APROBADO','OBSERVADO') DEFAULT 'PENDIENTE',
    FOREIGN KEY (id_asignacion) REFERENCES asignacion_tarea(id_asignacion)
);

CREATE TABLE planilla (
    id_planilla INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    total_horas_base DECIMAL(6,2),
    total_horas_extra DECIMAL(6,2),
    total_pago DECIMAL(10,2),
    estado ENUM('GENERADA','PAGADA') DEFAULT 'GENERADA',
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE planilla_detalle (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_planilla INT NOT NULL,
    fecha DATE NOT NULL,
    horas_base DECIMAL(4,2),
    horas_extra DECIMAL(4,2),
    pago_dia DECIMAL(8,2),
    FOREIGN KEY (id_planilla) REFERENCES planilla(id_planilla)
);

CREATE TABLE ajuste_planilla (
    id_ajuste INT AUTO_INCREMENT PRIMARY KEY,
    id_planilla INT NOT NULL,
    tipo ENUM('ADELANTO','DESCUENTO') NOT NULL,
    monto DECIMAL(8,2) NOT NULL,
    motivo VARCHAR(150),
    FOREIGN KEY (id_planilla) REFERENCES planilla(id_planilla)
);

CREATE TABLE ticket (
    id_ticket INT AUTO_INCREMENT PRIMARY KEY,
    id_registro INT NOT NULL,
    fecha_creacion DATE,
    motivo VARCHAR(200) NOT NULL,
    estado ENUM('ABIERTO','EN_REVISION','RESUELTO') DEFAULT 'ABIERTO',
    respuesta TEXT,
    FOREIGN KEY (id_registro) REFERENCES registro_diario(id_registro)
);

CREATE TABLE configuracion (
    id_configuracion INT AUTO_INCREMENT PRIMARY KEY,
    jornada_estandar DECIMAL(4,2) NOT NULL,
    multiplicador_horas_extras DECIMAL(4,2) NOT NULL,
    divisor_semanal DECIMAL(4,2) NOT NULL,
    divisor_mensual DECIMAL(4,2) NOT NULL
);

INSERT INTO configuracion (id_configuracion, jornada_estandar, multiplicador_horas_extras, divisor_semanal, divisor_mensual) VALUES (1, 8.5, 1.25, 6, 30);
