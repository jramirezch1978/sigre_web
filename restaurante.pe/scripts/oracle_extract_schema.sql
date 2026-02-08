-- ============================================================================
-- EXTRACTOR DE ESTRUCTURA COMPLETA DE BASE DE DATOS ORACLE 11gR2
-- Genera un JSON con: tablas, columnas, PKs, FKs, índices, constraints,
-- secuencias, vistas, triggers, procedimientos, funciones y paquetes.
-- ============================================================================
-- USO: Ejecutar en SQL*Plus o SQL Developer conectado a la BD objetivo.
--      El resultado se guarda en un archivo JSON.
--
--   @oracle_extract_schema.sql
--
-- O desde línea de comandos:
--   sqlplus usuario/password@sid @oracle_extract_schema.sql
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 32767
SET PAGESIZE 0
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET ECHO OFF
SET TERMOUT OFF

-- Archivo de salida
SPOOL schema_export.json

DECLARE
    v_owner       VARCHAR2(128) := USER;
    v_json        CLOB;
    v_first       BOOLEAN;
    v_first_inner BOOLEAN;
    v_count       NUMBER;

    -- Procedimiento para imprimir CLOB largo
    PROCEDURE print_clob(p_clob IN CLOB) IS
        v_offset  NUMBER := 1;
        v_chunk   NUMBER := 4000;
        v_length  NUMBER;
    BEGIN
        v_length := NVL(DBMS_LOB.GETLENGTH(p_clob), 0);
        WHILE v_offset <= v_length LOOP
            DBMS_OUTPUT.PUT(DBMS_LOB.SUBSTR(p_clob, v_chunk, v_offset));
            v_offset := v_offset + v_chunk;
        END LOOP;
    END;

    -- Escapar caracteres especiales para JSON
    FUNCTION json_escape(p_text IN VARCHAR2) RETURN VARCHAR2 IS
        v_result VARCHAR2(32767);
    BEGIN
        IF p_text IS NULL THEN
            RETURN '';
        END IF;
        v_result := REPLACE(p_text, '\', '\\');
        v_result := REPLACE(v_result, '"', '\"');
        v_result := REPLACE(v_result, CHR(10), '\n');
        v_result := REPLACE(v_result, CHR(13), '\r');
        v_result := REPLACE(v_result, CHR(9), '\t');
        RETURN v_result;
    END;

    -- Valor JSON string o null
    FUNCTION json_str(p_val IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF p_val IS NULL THEN
            RETURN 'null';
        ELSE
            RETURN '"' || json_escape(p_val) || '"';
        END IF;
    END;

    -- Valor JSON number o null
    FUNCTION json_num(p_val IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF p_val IS NULL THEN
            RETURN 'null';
        ELSE
            RETURN TO_CHAR(p_val);
        END IF;
    END;

BEGIN
    DBMS_OUTPUT.ENABLE(NULL);

    -- ========================================================================
    -- INICIO DEL JSON
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('{');
    DBMS_OUTPUT.PUT_LINE('  "metadata": {');
    DBMS_OUTPUT.PUT_LINE('    "database_version": "Oracle 11gR2",');
    DBMS_OUTPUT.PUT_LINE('    "schema_owner": "' || v_owner || '",');
    DBMS_OUTPUT.PUT_LINE('    "extraction_date": "' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '",');

    SELECT COUNT(*) INTO v_count FROM ALL_TABLES WHERE OWNER = v_owner;
    DBMS_OUTPUT.PUT_LINE('    "total_tables": ' || v_count || ',');

    SELECT COUNT(*) INTO v_count FROM ALL_VIEWS WHERE OWNER = v_owner;
    DBMS_OUTPUT.PUT_LINE('    "total_views": ' || v_count || ',');

    SELECT COUNT(*) INTO v_count FROM ALL_INDEXES WHERE OWNER = v_owner;
    DBMS_OUTPUT.PUT_LINE('    "total_indexes": ' || v_count || ',');

    SELECT COUNT(*) INTO v_count FROM ALL_SEQUENCES WHERE SEQUENCE_OWNER = v_owner;
    DBMS_OUTPUT.PUT_LINE('    "total_sequences": ' || v_count || ',');

    SELECT COUNT(*) INTO v_count FROM ALL_TRIGGERS WHERE OWNER = v_owner;
    DBMS_OUTPUT.PUT_LINE('    "total_triggers": ' || v_count || ',');

    SELECT COUNT(*) INTO v_count
      FROM ALL_OBJECTS
     WHERE OWNER = v_owner AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE');
    DBMS_OUTPUT.PUT_LINE('    "total_program_units": ' || v_count);

    DBMS_OUTPUT.PUT_LINE('  },');

    -- ========================================================================
    -- 1. TABLAS CON COLUMNAS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "tables": [');
    v_first := TRUE;

    FOR t IN (SELECT TABLE_NAME, NUM_ROWS, LAST_ANALYZED, TABLESPACE_NAME,
                     TEMPORARY, COMMENTS
                FROM (SELECT t.TABLE_NAME, t.NUM_ROWS, t.LAST_ANALYZED,
                             t.TABLESPACE_NAME, t.TEMPORARY, c.COMMENTS
                        FROM ALL_TABLES t
                        LEFT JOIN ALL_TAB_COMMENTS c
                          ON c.OWNER = t.OWNER AND c.TABLE_NAME = t.TABLE_NAME
                       WHERE t.OWNER = v_owner)
               ORDER BY TABLE_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || t.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "num_rows": ' || json_num(t.NUM_ROWS) || ',');
        DBMS_OUTPUT.PUT_LINE('      "tablespace": ' || json_str(t.TABLESPACE_NAME) || ',');
        DBMS_OUTPUT.PUT_LINE('      "temporary": "' || t.TEMPORARY || '",');
        DBMS_OUTPUT.PUT_LINE('      "comment": ' || json_str(t.COMMENTS) || ',');

        -- Columnas de la tabla
        DBMS_OUTPUT.PUT_LINE('      "columns": [');
        v_first_inner := TRUE;

        FOR col IN (SELECT c.COLUMN_NAME, c.DATA_TYPE, c.DATA_LENGTH,
                           c.DATA_PRECISION, c.DATA_SCALE, c.NULLABLE,
                           c.DATA_DEFAULT, c.COLUMN_ID, cc.COMMENTS
                      FROM ALL_TAB_COLUMNS c
                      LEFT JOIN ALL_COL_COMMENTS cc
                        ON cc.OWNER = c.OWNER
                       AND cc.TABLE_NAME = c.TABLE_NAME
                       AND cc.COLUMN_NAME = c.COLUMN_NAME
                     WHERE c.OWNER = v_owner
                       AND c.TABLE_NAME = t.TABLE_NAME
                     ORDER BY c.COLUMN_ID)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT_LINE('        ,');
            END IF;
            v_first_inner := FALSE;

            DBMS_OUTPUT.PUT(        '        {"column_name": "' || col.COLUMN_NAME || '"');
            DBMS_OUTPUT.PUT(        ', "data_type": "' || col.DATA_TYPE || '"');
            DBMS_OUTPUT.PUT(        ', "data_length": ' || json_num(col.DATA_LENGTH));
            DBMS_OUTPUT.PUT(        ', "data_precision": ' || json_num(col.DATA_PRECISION));
            DBMS_OUTPUT.PUT(        ', "data_scale": ' || json_num(col.DATA_SCALE));
            DBMS_OUTPUT.PUT(        ', "nullable": "' || col.NULLABLE || '"');
            DBMS_OUTPUT.PUT(        ', "data_default": ' || json_str(TRIM(SUBSTR(col.DATA_DEFAULT, 1, 500))));
            DBMS_OUTPUT.PUT(        ', "column_id": ' || json_num(col.COLUMN_ID));
            DBMS_OUTPUT.PUT_LINE(   ', "comment": ' || json_str(col.COMMENTS) || '}');
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('      ]');
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 2. PRIMARY KEYS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "primary_keys": [');
    v_first := TRUE;

    FOR pk IN (SELECT c.CONSTRAINT_NAME, c.TABLE_NAME, c.STATUS
                 FROM ALL_CONSTRAINTS c
                WHERE c.OWNER = v_owner
                  AND c.CONSTRAINT_TYPE = 'P'
                ORDER BY c.TABLE_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "constraint_name": "' || pk.CONSTRAINT_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || pk.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || pk.STATUS || '",');

        -- Columnas del PK
        DBMS_OUTPUT.PUT('      "columns": [');
        v_first_inner := TRUE;
        FOR pc IN (SELECT COLUMN_NAME
                     FROM ALL_CONS_COLUMNS
                    WHERE OWNER = v_owner
                      AND CONSTRAINT_NAME = pk.CONSTRAINT_NAME
                    ORDER BY POSITION)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
            v_first_inner := FALSE;
            DBMS_OUTPUT.PUT('"' || pc.COLUMN_NAME || '"');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(']');

        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 3. FOREIGN KEYS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "foreign_keys": [');
    v_first := TRUE;

    FOR fk IN (SELECT c.CONSTRAINT_NAME, c.TABLE_NAME, c.STATUS,
                      c.DELETE_RULE, r.TABLE_NAME AS REF_TABLE,
                      r.CONSTRAINT_NAME AS REF_CONSTRAINT
                 FROM ALL_CONSTRAINTS c
                 JOIN ALL_CONSTRAINTS r
                   ON r.OWNER = c.R_OWNER
                  AND r.CONSTRAINT_NAME = c.R_CONSTRAINT_NAME
                WHERE c.OWNER = v_owner
                  AND c.CONSTRAINT_TYPE = 'R'
                ORDER BY c.TABLE_NAME, c.CONSTRAINT_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "constraint_name": "' || fk.CONSTRAINT_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || fk.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || fk.STATUS || '",');
        DBMS_OUTPUT.PUT_LINE('      "delete_rule": "' || fk.DELETE_RULE || '",');
        DBMS_OUTPUT.PUT_LINE('      "ref_table": "' || fk.REF_TABLE || '",');
        DBMS_OUTPUT.PUT_LINE('      "ref_constraint": "' || fk.REF_CONSTRAINT || '",');

        -- Columnas origen
        DBMS_OUTPUT.PUT('      "columns": [');
        v_first_inner := TRUE;
        FOR fc IN (SELECT COLUMN_NAME
                     FROM ALL_CONS_COLUMNS
                    WHERE OWNER = v_owner
                      AND CONSTRAINT_NAME = fk.CONSTRAINT_NAME
                    ORDER BY POSITION)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
            v_first_inner := FALSE;
            DBMS_OUTPUT.PUT('"' || fc.COLUMN_NAME || '"');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('],');

        -- Columnas referenciadas
        DBMS_OUTPUT.PUT('      "ref_columns": [');
        v_first_inner := TRUE;
        FOR rc IN (SELECT COLUMN_NAME
                     FROM ALL_CONS_COLUMNS
                    WHERE OWNER = v_owner
                      AND CONSTRAINT_NAME = fk.REF_CONSTRAINT
                    ORDER BY POSITION)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
            v_first_inner := FALSE;
            DBMS_OUTPUT.PUT('"' || rc.COLUMN_NAME || '"');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(']');

        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 4. UNIQUE CONSTRAINTS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "unique_constraints": [');
    v_first := TRUE;

    FOR uk IN (SELECT c.CONSTRAINT_NAME, c.TABLE_NAME, c.STATUS
                 FROM ALL_CONSTRAINTS c
                WHERE c.OWNER = v_owner
                  AND c.CONSTRAINT_TYPE = 'U'
                ORDER BY c.TABLE_NAME, c.CONSTRAINT_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "constraint_name": "' || uk.CONSTRAINT_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || uk.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || uk.STATUS || '",');

        DBMS_OUTPUT.PUT('      "columns": [');
        v_first_inner := TRUE;
        FOR uc IN (SELECT COLUMN_NAME
                     FROM ALL_CONS_COLUMNS
                    WHERE OWNER = v_owner
                      AND CONSTRAINT_NAME = uk.CONSTRAINT_NAME
                    ORDER BY POSITION)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
            v_first_inner := FALSE;
            DBMS_OUTPUT.PUT('"' || uc.COLUMN_NAME || '"');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(']');

        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 5. CHECK CONSTRAINTS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "check_constraints": [');
    v_first := TRUE;

    FOR ck IN (SELECT c.CONSTRAINT_NAME, c.TABLE_NAME, c.STATUS,
                      c.SEARCH_CONDITION
                 FROM ALL_CONSTRAINTS c
                WHERE c.OWNER = v_owner
                  AND c.CONSTRAINT_TYPE = 'C'
                  AND c.GENERATED != 'GENERATED NAME'
                ORDER BY c.TABLE_NAME, c.CONSTRAINT_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "constraint_name": "' || ck.CONSTRAINT_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || ck.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || ck.STATUS || '",');
        DBMS_OUTPUT.PUT_LINE('      "search_condition": ' || json_str(SUBSTR(ck.SEARCH_CONDITION, 1, 2000)));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 6. INDICES
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "indexes": [');
    v_first := TRUE;

    FOR idx IN (SELECT i.INDEX_NAME, i.TABLE_NAME, i.UNIQUENESS,
                       i.INDEX_TYPE, i.TABLESPACE_NAME, i.STATUS,
                       i.NUM_ROWS, i.LAST_ANALYZED
                  FROM ALL_INDEXES i
                 WHERE i.OWNER = v_owner
                   AND i.INDEX_TYPE != 'LOB'
                 ORDER BY i.TABLE_NAME, i.INDEX_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "index_name": "' || idx.INDEX_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || idx.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "uniqueness": "' || idx.UNIQUENESS || '",');
        DBMS_OUTPUT.PUT_LINE('      "index_type": "' || idx.INDEX_TYPE || '",');
        DBMS_OUTPUT.PUT_LINE('      "tablespace": ' || json_str(idx.TABLESPACE_NAME) || ',');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || idx.STATUS || '",');

        -- Columnas del índice
        DBMS_OUTPUT.PUT('      "columns": [');
        v_first_inner := TRUE;
        FOR ic IN (SELECT COLUMN_NAME, DESCEND
                     FROM ALL_IND_COLUMNS
                    WHERE INDEX_OWNER = v_owner
                      AND INDEX_NAME = idx.INDEX_NAME
                    ORDER BY COLUMN_POSITION)
        LOOP
            IF NOT v_first_inner THEN
                DBMS_OUTPUT.PUT(', ');
            END IF;
            v_first_inner := FALSE;
            DBMS_OUTPUT.PUT('{"column": "' || ic.COLUMN_NAME || '", "order": "' || ic.DESCEND || '"}');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(']');

        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 7. SECUENCIAS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "sequences": [');
    v_first := TRUE;

    FOR seq IN (SELECT SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY,
                       CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, LAST_NUMBER
                  FROM ALL_SEQUENCES
                 WHERE SEQUENCE_OWNER = v_owner
                 ORDER BY SEQUENCE_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "sequence_name": "' || seq.SEQUENCE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "min_value": ' || json_num(seq.MIN_VALUE) || ',');
        DBMS_OUTPUT.PUT_LINE('      "max_value": ' || json_num(seq.MAX_VALUE) || ',');
        DBMS_OUTPUT.PUT_LINE('      "increment_by": ' || json_num(seq.INCREMENT_BY) || ',');
        DBMS_OUTPUT.PUT_LINE('      "cycle_flag": "' || seq.CYCLE_FLAG || '",');
        DBMS_OUTPUT.PUT_LINE('      "order_flag": "' || seq.ORDER_FLAG || '",');
        DBMS_OUTPUT.PUT_LINE('      "cache_size": ' || json_num(seq.CACHE_SIZE) || ',');
        DBMS_OUTPUT.PUT_LINE('      "last_number": ' || json_num(seq.LAST_NUMBER));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 8. VISTAS (compatible con Oracle 11gR2 — columna TEXT es LONG)
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "views": [');
    v_first := TRUE;

    FOR vw IN (SELECT v.VIEW_NAME, v.TEXT_LENGTH,
                      c.COMMENTS
                 FROM ALL_VIEWS v
                 LEFT JOIN ALL_TAB_COMMENTS c
                   ON c.OWNER = v.OWNER AND c.TABLE_NAME = v.VIEW_NAME
                WHERE v.OWNER = v_owner
                ORDER BY v.VIEW_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "view_name": "' || vw.VIEW_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "text_length": ' || json_num(vw.TEXT_LENGTH) || ',');
        DBMS_OUTPUT.PUT_LINE('      "comment": ' || json_str(vw.COMMENTS));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 9. TRIGGERS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "triggers": [');
    v_first := TRUE;

    FOR trg IN (SELECT TRIGGER_NAME, TABLE_NAME, TRIGGER_TYPE,
                       TRIGGERING_EVENT, STATUS, DESCRIPTION
                  FROM ALL_TRIGGERS
                 WHERE OWNER = v_owner
                 ORDER BY TABLE_NAME, TRIGGER_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "trigger_name": "' || trg.TRIGGER_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": ' || json_str(trg.TABLE_NAME) || ',');
        DBMS_OUTPUT.PUT_LINE('      "trigger_type": "' || trg.TRIGGER_TYPE || '",');
        DBMS_OUTPUT.PUT_LINE('      "triggering_event": "' || trg.TRIGGERING_EVENT || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || trg.STATUS || '",');
        DBMS_OUTPUT.PUT_LINE('      "description": ' || json_str(SUBSTR(trg.DESCRIPTION, 1, 2000)));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 10. PROCEDIMIENTOS, FUNCIONES Y PAQUETES
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "program_units": [');
    v_first := TRUE;

    FOR pu IN (SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, CREATED, LAST_DDL_TIME
                 FROM ALL_OBJECTS
                WHERE OWNER = v_owner
                  AND OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
                ORDER BY OBJECT_TYPE, OBJECT_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "name": "' || pu.OBJECT_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "type": "' || pu.OBJECT_TYPE || '",');
        DBMS_OUTPUT.PUT_LINE('      "status": "' || pu.STATUS || '",');
        DBMS_OUTPUT.PUT_LINE('      "created": "' || TO_CHAR(pu.CREATED, 'YYYY-MM-DD HH24:MI:SS') || '",');
        DBMS_OUTPUT.PUT_LINE('      "last_ddl_time": "' || TO_CHAR(pu.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') || '",');

        -- Parámetros (para procedimientos y funciones)
        IF pu.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION') THEN
            DBMS_OUTPUT.PUT('      "parameters": [');
            v_first_inner := TRUE;
            FOR prm IN (SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT, POSITION,
                               DATA_LENGTH, DATA_PRECISION, DATA_SCALE
                          FROM ALL_ARGUMENTS
                         WHERE OWNER = v_owner
                           AND OBJECT_NAME = pu.OBJECT_NAME
                           AND PACKAGE_NAME IS NULL
                           AND DATA_LEVEL = 0
                         ORDER BY POSITION)
            LOOP
                IF NOT v_first_inner THEN
                    DBMS_OUTPUT.PUT(', ');
                END IF;
                v_first_inner := FALSE;
                DBMS_OUTPUT.PUT('{"name": ' || json_str(prm.ARGUMENT_NAME));
                DBMS_OUTPUT.PUT(', "data_type": "' || prm.DATA_TYPE || '"');
                DBMS_OUTPUT.PUT(', "direction": "' || prm.IN_OUT || '"');
                DBMS_OUTPUT.PUT(', "position": ' || prm.POSITION || '}');
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(']');
        ELSE
            -- Para paquetes, listar los procedimientos/funciones del paquete
            DBMS_OUTPUT.PUT('      "subprograms": [');
            v_first_inner := TRUE;
            FOR sp IN (SELECT DISTINCT OBJECT_NAME AS SUBPROGRAM_NAME
                         FROM ALL_ARGUMENTS
                        WHERE OWNER = v_owner
                          AND PACKAGE_NAME = pu.OBJECT_NAME
                          AND DATA_LEVEL = 0
                        ORDER BY OBJECT_NAME)
            LOOP
                IF NOT v_first_inner THEN
                    DBMS_OUTPUT.PUT(', ');
                END IF;
                v_first_inner := FALSE;
                DBMS_OUTPUT.PUT('"' || sp.SUBPROGRAM_NAME || '"');
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(']');
        END IF;

        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 11. SYNONYMS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "synonyms": [');
    v_first := TRUE;

    FOR syn IN (SELECT SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK
                  FROM ALL_SYNONYMS
                 WHERE OWNER = v_owner
                 ORDER BY SYNONYM_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "synonym_name": "' || syn.SYNONYM_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_owner": "' || syn.TABLE_OWNER || '",');
        DBMS_OUTPUT.PUT_LINE('      "table_name": "' || syn.TABLE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "db_link": ' || json_str(syn.DB_LINK));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 12. DATABASE LINKS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "db_links": [');
    v_first := TRUE;

    FOR dbl IN (SELECT DB_LINK, USERNAME, HOST, CREATED
                  FROM ALL_DB_LINKS
                 WHERE OWNER = v_owner
                 ORDER BY DB_LINK)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "db_link": "' || dbl.DB_LINK || '",');
        DBMS_OUTPUT.PUT_LINE('      "username": ' || json_str(dbl.USERNAME) || ',');
        DBMS_OUTPUT.PUT_LINE('      "host": ' || json_str(dbl.HOST) || ',');
        DBMS_OUTPUT.PUT_LINE('      "created": "' || TO_CHAR(dbl.CREATED, 'YYYY-MM-DD HH24:MI:SS') || '"');
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 13. TIPOS DE DATOS PERSONALIZADOS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "types": [');
    v_first := TRUE;

    FOR tp IN (SELECT TYPE_NAME, TYPECODE, ATTRIBUTES, METHODS
                 FROM ALL_TYPES
                WHERE OWNER = v_owner
                ORDER BY TYPE_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "type_name": "' || tp.TYPE_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "typecode": "' || tp.TYPECODE || '",');
        DBMS_OUTPUT.PUT_LINE('      "attributes": ' || json_num(tp.ATTRIBUTES) || ',');
        DBMS_OUTPUT.PUT_LINE('      "methods": ' || json_num(tp.METHODS));
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 14. MATERIALIZED VIEWS
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "materialized_views": [');
    v_first := TRUE;

    FOR mv IN (SELECT MVIEW_NAME, REFRESH_MODE, REFRESH_METHOD,
                      BUILD_MODE, FAST_REFRESHABLE, LAST_REFRESH_DATE,
                      STALENESS
                 FROM ALL_MVIEWS
                WHERE OWNER = v_owner
                ORDER BY MVIEW_NAME)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT_LINE('    {');
        DBMS_OUTPUT.PUT_LINE('      "mview_name": "' || mv.MVIEW_NAME || '",');
        DBMS_OUTPUT.PUT_LINE('      "refresh_mode": "' || mv.REFRESH_MODE || '",');
        DBMS_OUTPUT.PUT_LINE('      "refresh_method": "' || mv.REFRESH_METHOD || '",');
        DBMS_OUTPUT.PUT_LINE('      "build_mode": "' || mv.BUILD_MODE || '",');
        DBMS_OUTPUT.PUT_LINE('      "fast_refreshable": "' || mv.FAST_REFRESHABLE || '",');
        DBMS_OUTPUT.PUT_LINE('      "last_refresh_date": ' || json_str(TO_CHAR(mv.LAST_REFRESH_DATE, 'YYYY-MM-DD HH24:MI:SS')) || ',');
        DBMS_OUTPUT.PUT_LINE('      "staleness": "' || mv.STALENESS || '"');
        DBMS_OUTPUT.PUT_LINE('    }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ],');

    -- ========================================================================
    -- 15. GRANTS (permisos sobre objetos del schema)
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('  "grants": [');
    v_first := TRUE;

    FOR gr IN (SELECT GRANTEE, TABLE_NAME, PRIVILEGE, GRANTABLE
                 FROM ALL_TAB_PRIVS
                WHERE GRANTOR = v_owner
                ORDER BY TABLE_NAME, GRANTEE, PRIVILEGE)
    LOOP
        IF NOT v_first THEN
            DBMS_OUTPUT.PUT_LINE('    ,');
        END IF;
        v_first := FALSE;

        DBMS_OUTPUT.PUT(    '    {"grantee": "' || gr.GRANTEE || '"');
        DBMS_OUTPUT.PUT(    ', "object": "' || gr.TABLE_NAME || '"');
        DBMS_OUTPUT.PUT(    ', "privilege": "' || gr.PRIVILEGE || '"');
        DBMS_OUTPUT.PUT_LINE(', "grantable": "' || gr.GRANTABLE || '"}');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  ]');

    -- ========================================================================
    -- FIN DEL JSON
    -- ========================================================================
    DBMS_OUTPUT.PUT_LINE('}');

END;
/

SPOOL OFF
SET TERMOUT ON
SET FEEDBACK ON

PROMPT
PROMPT ============================================
PROMPT  Exportacion completada: schema_export.json
PROMPT ============================================
PROMPT

EXIT;
