/*
DROP TABLE INVOICE_PAYMENT_LINK CASCADE CONSTRAINTS;
DROP TABLE SO_PARTNER_LINK CASCADE CONSTRAINTS;
DROP TABLE CUSTOMER_COMPANY_LINK CASCADE CONSTRAINTS;
DROP TABLE BILL_OF_MATERIAL CASCADE CONSTRAINTS;
DROP TABLE PURCHASE_ORDER_LINE CASCADE CONSTRAINTS;
DROP TABLE SALES_ORDER_LINE CASCADE CONSTRAINTS;
DROP TABLE INVENTORY CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE INVOICE CASCADE CONSTRAINTS;
DROP TABLE PURCHASE_ORDER CASCADE CONSTRAINTS;
DROP TABLE SALES_ORDER CASCADE CONSTRAINTS;
DROP TABLE SUPPLIER_CONTRACT CASCADE CONSTRAINTS;
DROP TABLE WAREHOUSE CASCADE CONSTRAINTS;
DROP TABLE PRODUCT CASCADE CONSTRAINTS;
DROP TABLE PRODUCT_CATEGORY CASCADE CONSTRAINTS;
DROP TABLE MATERIAL CASCADE CONSTRAINTS;
DROP TABLE VENDOR CASCADE CONSTRAINTS;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS;
DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;
DROP TABLE JOB_POSITION CASCADE CONSTRAINTS;
DROP TABLE DEPARTMENT CASCADE CONSTRAINTS;
DROP TABLE COMPANY CASCADE CONSTRAINTS;
*/
-- COMPANY Table
CREATE TABLE COMPANY
        (
                COMPANY_ID       NUMBER PRIMARY KEY    ,
                COMPANY_NAME     VARCHAR2(100) NOT NULL,
                ADDRESS          VARCHAR2(100)         ,
                POSTAL_CODE      VARCHAR2(20)          ,
                PHONE            VARCHAR2(20)          ,
                EMAIL            VARCHAR2(50)          ,
                TAX_ID           VARCHAR2(50)          ,
                ESTABLISHED_DATE DATE                  ,
                CREATED_ON       DATE                  ,
                CREATED_BY       VARCHAR2(50)
        );
-- JOB_POSITION Table
CREATE TABLE JOB_POSITION
        (
                JOB_POSITION_ID NUMBER PRIMARY KEY    ,
                POSITION_TITLE  VARCHAR2(100) NOT NULL,
                JOB_DESCRIPTION VARCHAR2(255)         ,
                CREATED_ON      DATE                  ,
                CREATED_BY      VARCHAR2(50)
        );
		
		
		
		
		
-- PRODUCT_CATEGORY Table
CREATE TABLE PRODUCT_CATEGORY
        (
                PRODUCT_CATEGORY_ID  NUMBER PRIMARY KEY    ,
                CATEGORY_NAME        VARCHAR2(100) NOT NULL,
                CATEGORY_DESCRIPTION VARCHAR2(255)         ,
                CREATED_ON           DATE                  ,
                CREATED_BY           VARCHAR2(50)
        );
-- MATERIAL Table
CREATE TABLE MATERIAL
        (
                MATERIAL_ID     NUMBER PRIMARY KEY    ,
                MATERIAL_CODE   VARCHAR2(50) NOT NULL ,
                MATERIAL_NAME   VARCHAR2(100)         ,
                DESCRIPTION     VARCHAR2(255)         ,
                UNIT_OF_MEASURE VARCHAR2(20)          ,
                CREATED_ON      DATE                  ,
                CREATED_BY      VARCHAR2(50)
        );
-- PAYMENT Table
CREATE TABLE PAYMENT
        (
                PAYMENT_ID     NUMBER PRIMARY KEY,
                PAYMENT_DATE   DATE              ,
                PAYMENT_AMOUNT NUMBER(14,2)      ,
                PAYMENT_METHOD VARCHAR2(50)      ,
                TRANSACTION_ID VARCHAR2(100)     ,
                PAYMENT_STATUS VARCHAR2(50)      ,
                CREATED_ON     DATE              ,
                CREATED_BY     VARCHAR2(50)
        );

-- DEPARTMENT (needs COMPANY first)

CREATE TABLE DEPARTMENT
        (
                DEPARTMENT_ID   NUMBER PRIMARY KEY    ,
                DEPARTMENT_NAME VARCHAR2(100) NOT NULL,
                DEPARTMENT_CODE VARCHAR2(20)          ,
                COMPANY_ID      NUMBER                ,
                MANAGER_ID      NUMBER                , -- FK added later (circular ref)
                LOCATION        VARCHAR2(100)         ,
                BUDGET          NUMBER(12,2)          ,
                CREATED_ON      DATE                  ,
                CREATED_BY      VARCHAR2(50)          ,
                CONSTRAINT fk_dept_company FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID) ON
                DELETE
                SET
                        NULL );

-- EMPLOYEE (needs DEPARTMENT, JOB_POSITION)

CREATE TABLE EMPLOYEE
        (
                EMPLOYEE_ID       NUMBER PRIMARY KEY   ,
                FIRST_NAME        VARCHAR2(50) NOT NULL,
                LAST_NAME         VARCHAR2(50)         ,
                EMAIL             VARCHAR2(100)        ,
                PHONE             VARCHAR2(20)         ,
                HIRE_DATE         DATE                 ,
                BIRTH_DATE        DATE                 ,
                DEPARTMENT_ID     NUMBER               , --fk
                JOB_POSITION_ID   NUMBER               , --fk
                SALARY            NUMBER(12,2)         ,
                EMPLOYMENT_STATUS VARCHAR2(50)         ,
                CREATED_ON        DATE                 ,
                CREATED_BY        VARCHAR2(50)         ,
                CONSTRAINT fk_emp_department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID) ON
                DELETE
                SET
                        NULL,
                        CONSTRAINT fk_emp_job FOREIGN KEY (JOB_POSITION_ID) REFERENCES JOB_POSITION(JOB_POSITION_ID) ON
                DELETE
                SET
                        NULL );
-- Add manager_id FK to DEPARTMENT (resolves circular reference)
ALTER TABLE DEPARTMENT
        ADD CONSTRAINT fk_dept_manager FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON
        DELETE
        SET
                NULL;

-- CUSTOMER 

CREATE TABLE CUSTOMER
        (
                CUSTOMER_ID    NUMBER PRIMARY KEY    ,
                CUSTOMER_NAME  VARCHAR2(100) NOT NULL,
                CONTACT_PERSON VARCHAR2(50)          ,
                EMAIL          VARCHAR2(50)          ,
                PHONE    VARCHAR2(20)                  ,
                ADDRESS           VARCHAR2(255)      ,
                POSTAL_CODE       VARCHAR2(20)       ,
                NATIONALITY       VARCHAR2(50)       ,
                CUSTOMER_TYPE     VARCHAR2(50)       ,
                REGISTRATION_DATE DATE               ,
                COMPANY_ID        NUMBER             ,
                CREATED_ON        DATE               ,
                CREATED_BY        VARCHAR2(50)       ,
                CONSTRAINT fk_cust_company FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID) ON
                DELETE
                SET
                        NULL );
					
					
--  VENDOR

CREATE TABLE VENDOR
        (
                VENDOR_ID      NUMBER PRIMARY KEY    ,
                COMPANY_ID     NUMBER                ,
                VENDOR_NAME    VARCHAR2(100) NOT NULL,
                CONTACT_PERSON VARCHAR2(100)         ,
                EMAIL          VARCHAR2(100)         ,
                PHONE          VARCHAR2(20)          ,
                ADDRESS        VARCHAR2(255)         ,
                POSTAL_CODE    VARCHAR2(20)          ,
                TAX_ID         VARCHAR2(50)          ,
                PAYMENT_TERMS  VARCHAR2(50)          ,
                CREATED_ON     DATE                  ,
                CREATED_BY     VARCHAR2(50)          ,
                CONSTRAINT fk_vendor_company FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID) ON
                DELETE
                SET
                        NULL );

-- PRODUCT 

CREATE TABLE PRODUCT
        (
                PRODUCT_ID          NUMBER PRIMARY KEY   ,
                PRODUCT_CODE        VARCHAR2(50) NOT NULL,
                PRODUCT_CATEGORY_ID NUMBER               ,
                PRODUCT_NAME        VARCHAR2(100)        ,
                DESCRIPTION         VARCHAR2(255)        ,
                UNIT_OF_MEASURE     VARCHAR2(20)         ,
                REORDER_LEVEL       NUMBER               ,
                CREATED_ON          DATE                 ,
                CREATED_BY          VARCHAR2(50)         ,
                CONSTRAINT fk_prod_category FOREIGN KEY (PRODUCT_CATEGORY_ID) REFERENCES PRODUCT_CATEGORY(PRODUCT_CATEGORY_ID) ON
                DELETE
                SET
                        NULL );

-- WAREHOUSE 

CREATE TABLE WAREHOUSE
        (
                WAREHOUSE_ID     NUMBER PRIMARY KEY    ,
                WAREHOUSE_NAME   VARCHAR2(100) NOT NULL,
                LOCATION         VARCHAR2(100)         ,
                ADDRESS          VARCHAR2(255)         ,
                POSTAL_CODE      VARCHAR2(20)          ,
                DEPARTMENT_ID    NUMBER                ,
                MANAGER_ID       NUMBER                ,
                STORAGE_CAPACITY NUMBER(12,2)          ,
                CREATED_ON       DATE                  ,
                CREATED_BY       VARCHAR2(50)          ,
                CONSTRAINT fk_wh_department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID) ON
                DELETE
                SET
                        NULL,
                        CONSTRAINT fk_warh_manag FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON
                DELETE
                SET
                        NULL );


-- INVENTORY 


CREATE TABLE INVENTORY
        (
                INVENTORY_ID       NUMBER PRIMARY KEY ,
                PRODUCT_ID         NUMBER             ,
                WAREHOUSE_ID       NUMBER             ,
                QUANTITY_ON_HAND   NUMBER             ,
                QUANTITY_RESERVED  NUMBER             ,
                QUANTITY_AVAILABLE NUMBER             ,
                LAST_STOCK_CHECK   DATE               ,
                COST_PER_UNIT      NUMBER(12,2)       ,
                CREATED_ON         DATE               ,
                CREATED_BY         VARCHAR2(50)       ,
                CONSTRAINT fk_inv_prod FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_inv_warhou FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSE(WAREHOUSE_ID) ON
                DELETE
                        CASCADE );

-- SALES_ORDER 
CREATE TABLE SALES_ORDER
        (
                SALES_ORDER_ID NUMBER PRIMARY KEY   ,
                ORDER_NUMBER   VARCHAR2(50) NOT NULL,
                CUSTOMER_ID    NUMBER               ,
                ORDER_DATE     DATE                 ,
                REQUIRED_DATE  DATE                 ,
                SHIPPED_DATE   DATE                 ,
                ORDER_STATUS   VARCHAR2(50)         ,
                TOTAL_AMOUNT   NUMBER(14,2)         ,
                PAYMENT_STATUS VARCHAR2(50)         ,
                CREATED_ON     DATE                 ,
                CREATED_BY     VARCHAR2(50)         ,
                CONSTRAINT fk_slord_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON
                DELETE
                SET
                        NULL );
-- SALES_ORDER_LINE (composite PK)
CREATE TABLE SALES_ORDER_LINE
        (
                SALES_ORDER_ID      NUMBER                                     ,
                LINE_NUMBER         NUMBER                                     ,
                PRODUCT_ID          NUMBER                                     ,
                QUANTITY_ORDERED    NUMBER                                     ,
                QUANTITY_SHIPPED    NUMBER                                     ,
                UNIT_PRICE          NUMBER(12,2)                               ,
                DISCOUNT_PERCENTAGE NUMBER(5,2)                                ,
                LINE_TOTAL          NUMBER(14,2)                               ,
                CREATED_ON          DATE                                       ,
                CREATED_BY          VARCHAR2(50)                               ,
                CONSTRAINT pk_so_line PRIMARY KEY (SALES_ORDER_ID, LINE_NUMBER),
                CONSTRAINT fk_sol_sales_order FOREIGN KEY (SALES_ORDER_ID) REFERENCES SALES_ORDER(SALES_ORDER_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_sol_product FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID) ON
                DELETE
                SET
                        NULL );
-- PURCHASE_ORDER 
CREATE TABLE PURCHASE_ORDER
        (
                PURCHASE_ORDER_ID      NUMBER PRIMARY KEY   ,
                PURCHASE_ORDER_NUMBER  VARCHAR2(50) NOT NULL,
                VENDOR_ID              NUMBER               ,
                EMPLOYEE_ID            NUMBER               ,
                ORDER_DATE             DATE                 ,
                REQUIRED_DELIVERY_DATE DATE                 ,
                RECEIVED_DATE          DATE                 ,
                ORDER_STATUS           VARCHAR2(50)         ,
                TOTAL_AMOUNT           NUMBER(14,2)         ,
                CREATED_ON             DATE                 ,
                CREATED_BY             VARCHAR2(20)         ,
                CONSTRAINT fk_purord_vendor FOREIGN KEY (VENDOR_ID) REFERENCES VENDOR(VENDOR_ID) ON
                DELETE
                SET
                        NULL,
                        CONSTRAINT fk_purord_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON
                DELETE
                SET
                        NULL );
-- PURCHASE_ORDER_LINE (composite PK)
CREATE TABLE PURCHASE_ORDER_LINE
        (
                PURCHASE_ORDER_ID NUMBER                                          ,
                LINE_NUMBER       NUMBER                                          ,
                MATERIAL_ID       NUMBER                                          ,
                QUANTITY_ORDERED  NUMBER                                          ,
                QUANTITY_RECEIVED NUMBER                                          ,
                UNIT_COST         NUMBER(12,2)                                    ,
                LINE_TOTAL        NUMBER(14,2)                                    ,
                CREATED_ON        DATE                                            ,
                CREATED_BY        VARCHAR2(20)                                    ,
                CONSTRAINT pk_po_line PRIMARY KEY (PURCHASE_ORDER_ID, LINE_NUMBER),
                CONSTRAINT fk_pol_purchase_order FOREIGN KEY (PURCHASE_ORDER_ID) REFERENCES PURCHASE_ORDER(PURCHASE_ORDER_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_pol_material FOREIGN KEY (MATERIAL_ID) REFERENCES MATERIAL(MATERIAL_ID) ON
                DELETE
                SET
                        NULL );

-- INVOICE 
CREATE TABLE INVOICE
        (
                INVOICE_ID     NUMBER PRIMARY KEY          ,
                INVOICE_NUMBER VARCHAR2(50) NOT NULL UNIQUE,
                SALES_ORDER_ID NUMBER                      ,
                CUSTOMER_ID    NUMBER                      ,
                INVOICE_DATE   DATE                        ,
                DUE_DATE       DATE                        ,
                SUB_TOTAL      NUMBER(14,2)                ,
                TAX_AMOUNT     NUMBER(12,2)                ,
                TOTAL_AMOUNT   NUMBER(14,2)                ,
                INVOICE_STATUS VARCHAR2(50)                ,
                PAYMENT_METHOD VARCHAR2(50)                ,
                CREATED_ON     DATE                        ,
                CREATED_BY     VARCHAR2(50)                ,
                CONSTRAINT fk_invo_sales_order FOREIGN KEY (SALES_ORDER_ID) REFERENCES SALES_ORDER(SALES_ORDER_ID) ON
                DELETE
                SET
                        NULL,
                        CONSTRAINT fk_inv_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON
                DELETE
                SET
                        NULL );

-- SUPPLIER_CONTRACT 


CREATE TABLE SUPPLIER_CONTRACT
        (
                SUPPLIER_CONTRACT_ID NUMBER PRIMARY KEY ,
                VENDOR_ID            NUMBER             ,
                COMPANY_ID           NUMBER             ,
                START_DATE           DATE               ,
                END_DATE             DATE               ,
                DELIVERY_TERMS       VARCHAR2(100)      ,
                PAYMENT_TERMS        VARCHAR2(50)       ,
                CONTRACT_STATUS      VARCHAR2(50)       ,
                CREATED_ON           DATE               ,
                CREATED_BY           VARCHAR2(50)       ,
                CONSTRAINT fk_sc_ven FOREIGN KEY (VENDOR_ID) REFERENCES VENDOR(VENDOR_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_sc_company FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID) ON
                DELETE
                        CASCADE );

-- CUSTOMER_COMPANY_LINK
CREATE TABLE CUSTOMER_COMPANY_LINK
        (
                CUSTOMER_ID NUMBER                                                ,
                COMPANY_ID  NUMBER                                                ,
                START_DATE  DATE                                                  ,
                CREATED_ON  DATE                                                  ,
                CREATED_BY  VARCHAR2(50)                                          ,
                CONSTRAINT pk_cust_comp_link PRIMARY KEY (CUSTOMER_ID, COMPANY_ID),
                CONSTRAINT fk_ccl_customer FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_ccl_company FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(COMPANY_ID) ON
                DELETE
                        CASCADE );
-- INVOICE_PAYMENT_LINK
CREATE TABLE INVOICE_PAYMENT_LINK
        (
                INVOICE_ID     NUMBER                                          ,
                PAYMENT_ID     NUMBER                                          ,
                AMOUNT_APPLIED NUMBER(14,2)                                    ,
                CREATED_ON     DATE                                            ,
                CREATED_BY     VARCHAR2(50)                                    ,
                CONSTRAINT pk_inv_pay_link PRIMARY KEY (INVOICE_ID, PAYMENT_ID),
                CONSTRAINT fk_ipl_invoice FOREIGN KEY (INVOICE_ID) REFERENCES INVOICE(INVOICE_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_ipl_payment FOREIGN KEY (PAYMENT_ID) REFERENCES PAYMENT(PAYMENT_ID) ON
                DELETE
                        CASCADE );
-- SO_PARTNER_LINK (Sales Order Partner)
CREATE TABLE SO_PARTNER_LINK
        (
                SALES_ORDER_ID NUMBER                                                           ,
                EMPLOYEE_ID    NUMBER                                                           ,
                PARTNER_ROLE   VARCHAR2(50)                                                     ,
                CREATED_ON     DATE                                                             ,
                CREATED_BY     VARCHAR2(50)                                                     ,
                CONSTRAINT pk_so_partner PRIMARY KEY (SALES_ORDER_ID, EMPLOYEE_ID, PARTNER_ROLE),
                CONSTRAINT fk_spl_sales_order FOREIGN KEY (SALES_ORDER_ID) REFERENCES SALES_ORDER(SALES_ORDER_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_spl_employee FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON
                DELETE
                        CASCADE );
-- BILL_OF_MATERIAL
CREATE TABLE BILL_OF_MATERIAL
        (
                PRODUCT_ID         NUMBER                              ,
                MATERIAL_ID        NUMBER                              ,
                COMPONENT_QUANTITY NUMBER                              ,
                UNIT_OF_MEASURE    VARCHAR2(20)                        ,
                CREATED_ON         DATE                                ,
                CREATED_BY         VARCHAR2(50)                        ,
                CONSTRAINT pk_blm PRIMARY KEY (PRODUCT_ID, MATERIAL_ID),
                CONSTRAINT fk_blm_product FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(PRODUCT_ID) ON
                DELETE
                        CASCADE,
                        CONSTRAINT fk_blm_material FOREIGN KEY (MATERIAL_ID) REFERENCES MATERIAL(MATERIAL_ID) ON
                DELETE
                        CASCADE );
-- ============================================
-- SEQUENCES FOR AUTO-INCREMENT IDs
-- ============================================
CREATE SEQUENCE seq_company
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_department
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_employee
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_job_position
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_customer
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vendor
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_product
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_product_category
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_warehouse
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_inventory
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_material
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sales_order
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_purchase_order
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_invoice
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_payment
START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_supplier_contract
START WITH 1 INCREMENT BY 1;
-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_employee_dept
ON employee
        (
                department_id
        )
;
CREATE INDEX idx_employee_job
ON employee
        (
                job_position_id
        )
;
CREATE INDEX idx_product_category
ON product
        (
                product_category_id
        )
;
CREATE INDEX idx_inventory_product
ON inventory
        (
                product_id
        )
;
CREATE INDEX idx_inventory_warehouse
ON inventory
        (
                warehouse_id
        )
;
CREATE INDEX idx_sales_order_customer
ON sales_order
        (
                customer_id
        )
;
CREATE INDEX idx_sales_order_date
ON sales_order
        (
                order_date
        )
;
CREATE INDEX idx_purchase_order_vendor
ON purchase_order
        (
                vendor_id
        )
;
CREATE INDEX idx_invoice_customer
ON invoice
        (
                customer_id
        )
;
CREATE INDEX idx_invoice_date
ON invoice
        (
                invoice_date
        )
;
COMMIT;
