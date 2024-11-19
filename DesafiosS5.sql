-- Desafio 1
SELECT 
    c.numrun AS RUT,
    INITCAP(c.pnombre || ' ' || c.appaterno || ' ' || c.apmaterno) AS Nombre,
    INITCAP(po.nombre_prof_ofic) AS Profesión,
    TO_CHAR(c.fecha_inscripcion, 'YYYY-MM-DD') AS Fecha_Inscripción,
    c.direccion AS Dirección
FROM cliente c
JOIN profesion_oficio po ON c.cod_prof_ofic = po.cod_prof_ofic
WHERE po.nombre_prof_ofic IN ('Contador', 'Vendedor')
  AND EXTRACT(YEAR FROM c.fecha_inscripcion) > (
      SELECT ROUND(AVG(EXTRACT(YEAR FROM fecha_inscripcion)))
      FROM cliente
  )
ORDER BY c.numrun;

-- Desafio 2
-- Creamos la tabla para almacenar el resultado
CREATE TABLE CLIENTES_CUPOS_COMPRA (
    RUT NUMBER(10),
    Edad NUMBER,
    Cupo_Disponible NUMBER(10)
);
-- Insertamos los datos filtrados en nuestra tabla
INSERT INTO CLIENTES_CUPOS_COMPRA (RUT, Edad, Cupo_Disponible)
SELECT 
    c.numrun AS RUT,
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM c.fecha_nacimiento) AS Edad,
    t.cupo_disp_compra AS Cupo_Disponible
FROM cliente c
JOIN tarjeta_cliente t ON c.numrun = t.numrun
WHERE t.cupo_disp_compra >= (
    SELECT MAX(t2.cupo_disp_compra)
    FROM tarjeta_cliente t2
    JOIN transaccion_tarjeta_cliente tt ON t2.nro_tarjeta = tt.nro_tarjeta
    WHERE EXTRACT(YEAR FROM tt.fecha_transaccion) = EXTRACT(YEAR FROM SYSDATE) - 1
);

-- La consulta para visualizar los datos
SELECT * FROM CLIENTES_CUPOS_COMPRA;