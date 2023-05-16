-------------- create schema ------------
CREATE SCHEMA IF NOT EXISTS "secret_manager";
set schema 'secret_manager';

CREATE TABLE IF NOT EXISTS secret_type (
	id varchar(100) NOT NULL,
	schema json default '{}',
	PRIMARY KEY (id)
);
-- id: [user-defined] e.g: elastic-search

CREATE TABLE IF NOT EXISTS secret (
	id varchar(100) NOT NULL, 
	secret_type_id varchar(100) NOT NULL,
	data text default '{}', -- Encrypted secret value
	PRIMARY KEY (id),
	FOREIGN KEY(secret_type_id) REFERENCES secret_type(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bindings (
	id varchar(100) NOT NULL, 
	binding_type varchar(20),
	secret_type_id varchar(100) NOT NULL,
	data json default '{}',
	binding_entity VARCHAR(100) NOT NULL,
	binding_entity_value VARCHAR(100) NOT NULL,
	UNIQUE (binding_type, secret_type_id, binding_entity, binding_entity_value),
	PRIMARY KEY (id),
	FOREIGN KEY(secret_type_id) REFERENCES secret_type(id) ON DELETE CASCADE
);
-- id: [ksuid]
-- binding_type: e.g: "producer" / "consumer"
-- binding_entity: eg: moduleId or moduleClass
-- binding_entity_value: eg:"terraform-aws-eks@v1.0.0"(module_id), "infrastructure"(module_class)
