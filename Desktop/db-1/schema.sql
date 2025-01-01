create table cache
(
    `key`      varchar(255) not null
        primary key,
    value      mediumtext   not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table cache_locks
(
    `key`      varchar(255) not null
        primary key,
    owner      varchar(255) not null,
    expiration int          not null
)
    collate = utf8mb4_unicode_ci;

create table departments
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255) not null,
    description text         null,
    created_at  timestamp    null,
    updated_at  timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table employees
(
    id            bigint unsigned auto_increment
        primary key,
    name          varchar(255)                   not null,
    email         varchar(255)                   not null,
    position      varchar(255) default 'Unknown' not null,
    department_id bigint unsigned                not null,
    start_date    date                           not null,
    created_at    timestamp                      null,
    updated_at    timestamp                      null,
    constraint employees_email_unique
        unique (email),
    constraint employees_department_id_foreign
        foreign key (department_id) references departments (id)
)
    collate = utf8mb4_unicode_ci;

create table failed_jobs
(
    id         bigint unsigned auto_increment
        primary key,
    uuid       varchar(255)                          not null,
    connection text                                  not null,
    queue      text                                  not null,
    payload    longtext                              not null,
    exception  longtext                              not null,
    failed_at  timestamp default current_timestamp() not null,
    constraint failed_jobs_uuid_unique
        unique (uuid)
)
    collate = utf8mb4_unicode_ci;

create table job_batches
(
    id             varchar(255) not null
        primary key,
    name           varchar(255) not null,
    total_jobs     int          not null,
    pending_jobs   int          not null,
    failed_jobs    int          not null,
    failed_job_ids longtext     not null,
    options        mediumtext   null,
    cancelled_at   int          null,
    created_at     int          not null,
    finished_at    int          null
)
    collate = utf8mb4_unicode_ci;

create table jobs
(
    id           bigint unsigned auto_increment
        primary key,
    queue        varchar(255)     not null,
    payload      longtext         not null,
    attempts     tinyint unsigned not null,
    reserved_at  int unsigned     null,
    available_at int unsigned     not null,
    created_at   int unsigned     not null
)
    collate = utf8mb4_unicode_ci;

create index jobs_queue_index
    on jobs (queue);

create table leave_types
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255)  not null,
    description text          null,
    max_days    int default 0 not null,
    created_at  timestamp     null,
    updated_at  timestamp     null
)
    collate = utf8mb4_unicode_ci;

create table leave_entitements
(
    id               bigint unsigned auto_increment
        primary key,
    employee_id      bigint unsigned not null,
    leave_type_e_id  bigint unsigned not null,
    entitlement_days int             not null,
    used_days        int default 0   not null,
    remaining_days   int default 0   not null,
    created_at       timestamp       null,
    updated_at       timestamp       null,
    constraint leave_entitements_employee_id_foreign
        foreign key (employee_id) references employees (id),
    constraint leave_entitements_leave_type_e_id_foreign
        foreign key (leave_type_e_id) references leave_types (id)
)
    collate = utf8mb4_unicode_ci;

create table leaves
(
    id            bigint unsigned auto_increment
        primary key,
    employee_id   bigint unsigned                                                  not null,
    leave_type_id bigint unsigned                                                  not null,
    start_date    date                                                             not null,
    end_date      date                                                             not null,
    reason        text                                     default 'Not Specified' not null,
    status        enum ('pending', 'approved', 'rejected') default 'pending'       not null,
    created_at    timestamp                                                        null,
    updated_at    timestamp                                                        null,
    constraint leaves_employee_id_foreign
        foreign key (employee_id) references employees (id),
    constraint leaves_leave_type_id_foreign
        foreign key (leave_type_id) references leave_types (id)
)
    collate = utf8mb4_unicode_ci;

create table migrations
(
    id        int unsigned auto_increment
        primary key,
    migration varchar(255) not null,
    batch     int          not null
)
    collate = utf8mb4_unicode_ci;

create table roles
(
    id          bigint unsigned auto_increment
        primary key,
    name        varchar(255) not null,
    description text         null,
    created_at  timestamp    null,
    updated_at  timestamp    null,
    constraint roles_name_unique
        unique (name)
)
    collate = utf8mb4_unicode_ci;

create table sessions
(
    id            varchar(255)    not null
        primary key,
    user_id       bigint unsigned null,
    ip_address    varchar(45)     null,
    user_agent    text            null,
    payload       longtext        not null,
    last_activity int             not null
)
    collate = utf8mb4_unicode_ci;

create index sessions_last_activity_index
    on sessions (last_activity);

create index sessions_user_id_index
    on sessions (user_id);

create table users
(
    id            bigint unsigned auto_increment
        primary key,
    name          varchar(255)    not null,
    email         varchar(255)    not null,
    password      varchar(255)    not null,
    employee_e_id bigint unsigned not null,
    created_at    timestamp       null,
    updated_at    timestamp       null,
    constraint users_email_unique
        unique (email),
    constraint users_employee_e_id_foreign
        foreign key (employee_e_id) references employees (id)
)
    collate = utf8mb4_unicode_ci;

create table leave_approvals
(
    id            bigint unsigned auto_increment
        primary key,
    user_id       bigint unsigned                                            not null,
    leave_id      bigint unsigned                                            not null,
    status        enum ('pending', 'approved', 'rejected') default 'pending' not null,
    comment       text                                                       null,
    approval_date timestamp                                                  null,
    created_at    timestamp                                                  null,
    updated_at    timestamp                                                  null,
    constraint leave_approvals_leave_id_foreign
        foreign key (leave_id) references leaves (id),
    constraint leave_approvals_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table roles_users
(
    id         bigint unsigned auto_increment
        primary key,
    role_id    bigint unsigned not null,
    user_id    bigint unsigned not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint roles_users_role_id_foreign
        foreign key (role_id) references roles (id),
    constraint roles_users_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table workday_and_holidays
(
    id          bigint unsigned auto_increment
        primary key,
    date        date                                          not null,
    type        enum ('workday', 'holiday') default 'workday' not null,
    description text                                          null,
    created_at  timestamp                                     null,
    updated_at  timestamp                                     null
)
    collate = utf8mb4_unicode_ci;


