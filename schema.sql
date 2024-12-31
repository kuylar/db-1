create table currencies
(
    id         bigint unsigned auto_increment
        primary key,
    code       varchar(255) not null,
    name       varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table currency_values
(
    id          bigint unsigned auto_increment
        primary key,
    currency_id bigint unsigned not null,
    value       double          not null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    constraint currency_values_currency_id_foreign
        foreign key (currency_id) references currencies (id)
)
    collate = utf8mb4_unicode_ci;

create table ilces
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    `key`      int          not null,
    sehir_key  int          not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table mahalles
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    `key`      int          not null,
    ilce_key   int          not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table news_categories
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table password_reset_tokens
(
    email      varchar(255) not null
        primary key,
    token      varchar(255) not null,
    created_at timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table sehirs
(
    id         bigint unsigned auto_increment
        primary key,
    name       varchar(255) not null,
    `key`      int          not null,
    created_at timestamp    null,
    updated_at timestamp    null
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

create table stocks
(
    id          bigint unsigned auto_increment
        primary key,
    code        varchar(255) not null,
    name        varchar(255) not null,
    description longtext     null,
    created_at  timestamp    null,
    updated_at  timestamp    null
)
    collate = utf8mb4_unicode_ci;

create table news_posts
(
    id          bigint unsigned auto_increment
        primary key,
    stock_id    bigint unsigned not null,
    title       text            not null,
    summary     text            not null,
    content     text            null,
    image       text            null,
    source      text            null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    category_id bigint unsigned not null,
    constraint news_posts_category_id_foreign
        foreign key (category_id) references news_categories (id),
    constraint news_posts_stock_id_foreign
        foreign key (stock_id) references stocks (id)
)
    collate = utf8mb4_unicode_ci;

create table stock_values
(
    id         bigint unsigned auto_increment
        primary key,
    stock_id   bigint unsigned not null,
    value      double          not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    constraint stock_values_stock_id_foreign
        foreign key (stock_id) references stocks (id)
)
    collate = utf8mb4_unicode_ci;

create table users
(
    id                bigint unsigned auto_increment
        primary key,
    first_name        varchar(255) not null,
    last_name         varchar(255) not null,
    email             varchar(255) not null,
    email_verified_at timestamp    null,
    password          varchar(255) not null,
    remember_token    varchar(100) null,
    created_at        timestamp    null,
    updated_at        timestamp    null,
    constraint users_email_unique
        unique (email)
)
    collate = utf8mb4_unicode_ci;

create table user_accounts
(
    id          bigint unsigned auto_increment
        primary key,
    user_id     bigint unsigned not null,
    currency_id bigint unsigned not null,
    created_at  timestamp       null,
    updated_at  timestamp       null,
    constraint user_accounts_currency_id_foreign
        foreign key (currency_id) references currencies (id),
    constraint user_accounts_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table transactions
(
    id               bigint unsigned auto_increment
        primary key,
    user_id          bigint unsigned                             not null,
    account_id       bigint unsigned                             not null,
    transaction_type enum ('withdraw', 'deposit', 'buy', 'sell') not null,
    stock_id         bigint unsigned                             null,
    amount           double                                      not null,
    created_at       timestamp                                   null,
    updated_at       timestamp                                   null,
    constraint transactions_account_id_foreign
        foreign key (account_id) references user_accounts (id),
    constraint transactions_stock_id_foreign
        foreign key (stock_id) references stocks (id),
    constraint transactions_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table user_addresses
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned not null,
    sehir_id   bigint unsigned not null,
    ilce_id    bigint unsigned not null,
    mahalle_id bigint unsigned not null,
    created_at timestamp       null,
    updated_at timestamp       null,
    address    text            not null,
    constraint user_addresses_ilce_id_foreign
        foreign key (ilce_id) references ilces (id),
    constraint user_addresses_mahalle_id_foreign
        foreign key (mahalle_id) references mahalles (id),
    constraint user_addresses_sehir_id_foreign
        foreign key (sehir_id) references sehirs (id),
    constraint user_addresses_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table user_login_histories
(
    id         bigint unsigned auto_increment
        primary key,
    user_id    bigint unsigned                          not null,
    login_type enum ('login', 'logout') default 'login' not null,
    params     varchar(255)                             not null,
    created_at timestamp                                null,
    updated_at timestamp                                null,
    constraint user_login_histories_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

create table user_stocks
(
    id                bigint unsigned auto_increment
        primary key,
    user_id           bigint unsigned                             not null,
    stock_id          bigint unsigned                             not null,
    transaction_type  enum ('withdraw', 'deposit', 'buy', 'sell') not null,
    stock_amount      int                                         not null,
    base_money_amount double                                      not null comment 'Alınan tarihteki fiyat',
    created_at        timestamp                                   null,
    updated_at        timestamp                                   null,
    constraint user_stocks_stock_id_foreign
        foreign key (stock_id) references stocks (id),
    constraint user_stocks_user_id_foreign
        foreign key (user_id) references users (id)
)
    collate = utf8mb4_unicode_ci;

