/* DATABASE SCHEMA : zephyr.db :: sqlite3                              */ 

CREATE TABLE IF NOT EXISTS provider ( 
    provider_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    provider_name TEXT    NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS region (
    region_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    region_provider_id INTEGER NOT NULL,
    region_name        TEXT    NOT NULL,
    FOREIGN KEY ( region_provider_id ) 
        REFERENCES provider ( provider_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS zone (
    zone_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    zone_region_id INTEGER NOT NULL,
    zone_name      TEXT    NOT NULL,
    FOREIGN KEY ( zone_region_id )
        REFERENCES region ( region_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS account (
    account_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    account_provider_id INTEGER NOT NULL,
    account_name        TEXT    NOT NULL,
    account_number      TEXT    NOT NULL,
    FOREIGN KEY ( account_provider_id )
        REFERENCES provider ( provider_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS network (
    network_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    network_account_id INTEGER NOT NULL,
    network_region_id  INTEGER NOT NULL,
    network_name       TEXT    NOT NULL,
    FOREIGN KEY ( network_account_id )
        REFERENCES account ( account_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( network_region_id )
        REFERENCES region ( region_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS subnet (
    subnet_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    subnet_zone_id    INTEGER NOT NULL,
    subnet_network_id INTEGER NOT NULL,
    subnet_name       TEXT    NOT NULL,
    FOREIGN KEY ( subnet_zone_id )
        REFERENCES zone ( zone_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( subnet_network_id )
        REFERENCES network ( network_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS firewall (
    firewall_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    firewall_network_id INTEGER NOT NULL,
    firewall_name       TEXT    NOT NULL,
    FOREIGN KEY ( firewall_network_id )
        REFERENCES network ( network_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS user (
    user_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    user_username TEXT    NOT NULL,
    user_email    TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS account_permission (
    account_permission_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    account_permission_account_id INTEGER NOT NULL,
    account_permission_user_id    INTEGER NOT NULL,
    FOREIGN KEY ( account_permission_account_id )
        REFERENCES account ( account_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( account_permission_user_id )
        REFERENCES user ( user_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS manager_host (
    manager_host_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    manager_host_hostname   TEXT    NOT NULL,
    manager_host_ip_address TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS submit_host (
    submit_host_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    submit_host_hostname   TEXT    NOT NULL,
    submit_host_ip_address TEXT    NOT NULL
);

CREATE TABLE IF NOT EXISTS job (
    job_id               INTEGER PRIMARY KEY AUTOINCREMENT,
    job_submit_host_id   INTEGER NOT NULL,
    job_account_id       INTEGER NOT NULL,
    job_user_id          INTEGER NOT NULL,
    job_validation_time  INTEGER NOT NULL CHECK ( job_validation_time > 0 ),
    job_cluster_id       INTEGER NOT NULL,
    job_process_id       INTEGER NOT NULL CHECK ( job_process_id >= 0 ),
    job_request_cpus     INTEGER NOT NULL CHECK ( job_request_cpus > 0 ),
    job_request_memory   INTEGER NOT NULL CHECK ( job_request_memory > 0 ),
    job_request_disk     INTEGER NOT NULL CHECK ( job_request_disk > 0 ),
    job_request_walltime INTEGER NOT NULL CHECK ( job_request_walltime > 0 ),
    job_status           INTEGER NOT NULL CHECK ( job_status >= 0 AND job_status <= 6 ),
    job_queue_time       INTEGER NOT NULL CHECK ( job_queue_time > 0 ),   
    FOREIGN KEY ( job_submit_host_id ) 
        REFERENCES submit_host ( submit_host_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( job_account_id )
        REFERENCES account ( account_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( job_user_id )
        REFERENCES user ( user_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS machine_type (
    machine_type_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    machine_type_provider_id INTEGER NOT NULL,  
    machine_type_name        TEXT    NOT NULL,
    machine_type_cpus        INTEGER NOT NULL CHECK ( machine_type_cpus > 0 ),
    machine_type_memory      INTEGER NOT NULL CHECK ( machine_type_memory > 0 ),
    machine_type_disk        INTEGER NOT NULL CHECK ( machine_type_disk > 0 ),
    FOREIGN KEY ( machine_type_provider_id )
        REFERENCES provider ( provider_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS price (
    price_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    price_zone_id         INTEGER NOT NULL,
    price_machine_type_id INTEGER NOT NULL,
    price_ask             REAL    NOT NULL CHECK ( price_ask > 0.0 ),
    FOREIGN KEY ( price_zone_id )
        REFERENCES zone ( zone_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( price_machine_type_id )
        REFERENCES machine_type ( machine_type_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS image (
    image_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    image_account_id INTEGER NOT NULL,
    image_region_id  INTEGER NOT NULL,
    image_name       TEXT    NOT NULL,
    FOREIGN KEY ( image_account_id )
        REFERENCES account ( account_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( image_region_id )                                                                                                                     
        REFERENCES region ( region_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS keypair (
    keypair_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    keypair_account_id INTEGER NOT NULL,
    keypair_region_id  INTEGER NOT NULL, 
    keypair_name       TEXT    NOT NULL,
    FOREIGN KEY ( keypair_account_id )
        REFERENCES account ( account_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( keypair_region_id )
        REFERENCES region ( region_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS request (
    request_id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    request_job_submit_host_id  INTEGER NOT NULL,
    request_job_account_id      INTEGER NOT NULL,
    request_job_user_id         INTEGER NOT NULL,
    request_job_validation_time INTEGER NOT NULL, 
    request_job_cluster_id      INTEGER NOT NULL,
    request_manager_host_id     INTEGER NOT NULL,
    request_machine_type_id     INTEGER NOT NULL, 
    request_subnet_id           INTEGER NOT NULL,
    request_firewall_id         INTEGER NOT NULL,
    request_image_id            INTEGER NOT NULL,
    request_keypair_id          INTEGER NOT NULL,
    request_bid                 REAL    NOT NULL CHECK ( request_bid > 0.0 ),
    request_count               INTEGER NOT NULL CHECK ( request_count > 0 ),
    request_status              INTEGER NOT NULL,
    request_time                INTEGER NOT NULL CHECK ( request_time > 0 ),  
    FOREIGN KEY ( request_job_submit_host_id, request_job_account_id, request_job_user_id, request_job_validation_time, request_job_cluster_id )
        REFERENCES job ( job_submit_host_id, job_account_id, job_user_id, job_validation_time, job_cluster_id ) 
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_manager_host_id )
        REFERENCES manager_host ( manager_host_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_machine_type_id )
        REFERENCES machine_type ( machine_type_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_subnet_id )
        REFERENCES subnet ( subnet_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_firewall_id )
        REFERENCES firewall ( firewall_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_image_id )
        REFERENCES image ( image_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY ( request_keypair_id )
        REFERENCES keypair ( keypair_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS machine (
    machine_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    machine_request_id INTEGER NOT NULL,
    FOREIGN KEY ( machine_request_id )
        REFERENCES machine_request_id ( machine_request_id )
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

/* END DATABASE SCHEMA : zephyr.db :: sqlite3                         */
