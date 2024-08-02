CREATE TABLE tblEmailDetails (
    emailId int primary key AUTO_INCREMENT,
    emailAddress varchar(128) not null,
    emailPassword char(28) not null,
    emailHost varchar(64) not null,
    emailPort char(4) not null,
    emailEncryption char(1) not null,
    isEmailSecure char(1) not null,
    emailCreatedDate datetime not null default CURRENT_TIMESTAMP
);
CREATE TABLE tblEmailAlias (
    aliasId int primary key AUTO_INCREMENT,
    aliasType varchar(32) not null,
    aliasName varchar(64) not null,
    aliasEmailId int not null,
    aliasCreatedDate datetime not null default CURRENT_TIMESTAMP,
    aliasUpdatedDate datetime on update CURRENT_TIMESTAMP
);
CREATE TABLE tblUsers (
    userId int primary key AUTO_INCREMENT,
    userFirstName varchar(32) not null,
    userLastName varchar(32) not null,
    userEmail varchar(128) not null,
    userPhoneNumber char(10) not null,
    userWhatsappNumber char(10) not null,
    userAddress json not null,
    userEmailVerified char(1) not null default '0',
    userMobileVerified char(1) not null default '0',
    userWhatsappVerified char(1) not null default '0',
    userLogin varchar(32) not null,
    userPassword char(60) not null,
    userAccessToken char(128),
    userRefreshToken char(128),
    userRoleId int not null,
    isUserActive char(1) not null default '0',
    userCreatedDate datetime not null default CURRENT_TIMESTAMP
);
CREATE TABLE tblUserVerificationDetails (
    verificationId int primary key AUTO_INCREMENT,
    verificationType char(1) not null,
    verificationKeyType char(1) not null,
    verificationValue varchar(128) not null,
    verificationStatus char(1) not null default '1',
    verificationCreatedDate datetime null default CURRENT_TIMESTAMP
);
CREATE TABLE tblCustomers (
    customerId int primary key AUTO_INCREMENT,
    customerFirstName varchar(128) not null,
    customerLastName varchar(128) not null,
    customerEmail varchar(128) not null,
    customerPhoneNumber char(10) not null,
    customerAddress json not null,
    customerCreatedDate datetime not null default CURRENT_TIMESTAMP,
    customerUpdatedDate datetime on update CURRENT_TIMESTAMP
);
CREATE TABLE tblEmailTemplates (
    templateId int primary key AUTO_INCREMENT,
    templateName varchar(64) not null,
    templateSubject varchar(128),
    templateBody longtext not null,
    isTemplateActive char(1) not null default '1',
    templateCreatedDate datetime not null default CURRENT_TIMESTAMP
);
CREATE TABLE tblWhatsappTemplates (
    templateId int primary key AUTO_INCREMENT,
    templateName varchar(64) not null,
    templateBody text not null,
    templateIdentifire varchar(128) not null,
    isTemplateActive char(1) not null default '1',
    templateCreatedDate datetime not null default CURRENT_TIMESTAMP
);
CREATE TABLE tblSmstemplates (
    templateId int primary key AUTO_INCREMENT,
    templateName varchar(64) not null,
    templateSubject varchar(128),
    templateBody text not null,
    isTemplateActive char(1) not null default '1',
    templateCreatedDate datetime not null default CURRENT_TIMESTAMP
);
CREATE TABLE tblBankDetails (
    bankId int primary key AUTO_INCREMENT,
    bankName varchar(64) not null,
    bankAccountNumber char(18) not null,
    bankContactNumber char(10) not null,
    bankEmailAddress varchar(128) not null,
    bankAddress json not null,
    bankIfscCode char(11) not null,
    bankAccountBalance decimal(13, 2) not null default 0.00,
    isBankAccountActive char(1) not null default '1'
);
CREATE TABLE tblPaymentGateway (
    pgId int primary key AUTO_INCREMENT,
    pgAccountId varchar(32) not null,
    pgName varchar(32) not null,
    pgApiKey varchar(64) not null,
    pgApiSecret varchar(64) not null,
    pgHash varchar(128) not null,
    pgBankAccountId int not null,
    pgCreatedDate datetime not null default CURRENT_TIMESTAMP,
    FOREIGN KEY (pgBankAccountId) REFERENCES tblBankDetails(bankId)
);
CREATE TABLE tblSpAccounts (
    accountId int primary key AUTO_INCREMENT,
    spAccountId varchar(16) not null UNIQUE,
    accountDomain varchar(32) not null UNIQUE,
    accountName varchar(128) not null,
    accountEmail varchar(128) not null,
    accountPhone varchar(16) not null,
    accountApiKey char(32) not null,
    accountApiPassword char(38) not null,
    accountApiSecret char(38) not null,
    accountLogo varchar(64) not null,
    accountActiveWhatsappId int,
    accountActiveEmailId int not null,
    accountActivePaymentGatewayId int not null,
    accountActiveSmsId int,
    accountCreatedDate datetime not null default CURRENT_TIMESTAMP,
    accountUpdatedDate datetime on update CURRENT_TIMESTAMP,
    FOREIGN KEY (accountActiveEmailId) REFERENCES tblEmailDetails (emailId),
    FOREIGN KEY (accountActivePaymentGatewayId) REFERENCES tblPaymentGateway (pgId)
);
CREATE TABLE tblInvoices (
    invoiceId int primary key AUTO_INCREMENT,
    invoiceNumber char(5) not null UNIQUE,
    invoiceNumberFormated char(16) not null UNIQUE,
    invoiceAmount decimal(10, 2) not null default 0.00,
    invoiceCustomerId int not null,
    invoiceAccountId int not null,
    invoiceCreatedDate datetime not null default CURRENT_TIMESTAMP,
    FOREIGN KEY (invoiceCustomerId) REFERENCES tblCustomers (customerId),
    FOREIGN KEY (invoiceAccountId) REFERENCES tblSpAccounts (accountId)
);
CREATE TABLE tblSpOrders (
    orderId int primary key AUTO_INCREMENT,
    spOrderId varchar(16) not null,
    spOrderItemId varchar(16) not null,
    orderAccountId int not null,
    orderCustomerId int not null,
    orderStatus varchar(16) not null,
    spOrderStatus varchar(16) not null,
    orderType varchar(16) not null,
    orderNumber char(5) not null UNIQUE,
    orderNumberFormated char(16) not null UNIQUE,
    orderQuantity int not null,
    orderProductId int not null,
    orderVariantId int not null,
    orderPaymentType varchar(16) not null,
    orderPaymentMethod varchar(16) not null,
    orderInvoiceId int not null,
    isOrderHold char(1) not null default '0',
    isOrderFlagged char(1) not null default '0',
    orderCreatedDate datetime not null,
    orderInsertedDate datetime not null default CURRENT_TIMESTAMP,
    FOREIGN KEY (orderAccountId) REFERENCES tblSpAccounts (accountId),
    FOREIGN KEY (orderCustomerId) REFERENCES tblCustomers (customerId)
);