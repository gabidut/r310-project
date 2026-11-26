DROP DATABASE IF EXISTS MLR3;

CREATE DATABASE IF NOT EXISTS MLR3;
USE MLR3;
# -----------------------------------------------------------------------------
#       TABLE : TD_CHECKLIST
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_CHECKLIST
 (
   ETA_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   CHE_LIBELLE CHAR(32) NOT NULL  ,
   CHE_DESCRIPTION CHAR(32) NOT NULL  ,
   CHE_STATUT CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_CHECKLIST
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_CHECKLIST_TD_ETAPE_CHECKLIST
     ON TD_CHECKLIST (ETA_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_REUNION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_REUNION
 (
   REU_ID CHAR(32) NOT NULL  ,
   REU_NOM CHAR(32) NOT NULL  ,
   REU_DATE DATETIME NOT NULL  ,
   REU_STATUT CHAR(32) NOT NULL  ,
   REU_LIEU CHAR(32) NOT NULL  
   , PRIMARY KEY (REU_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_COMPTE_RENDU
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_COMPTE_RENDU
 (
   COM_ID CHAR(32) NOT NULL  ,
   TYC_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   COM_ORDRE CHAR(32) NOT NULL  ,
   COM_DATE DATETIME NOT NULL  ,
   COM_DESCRIPTION VARCHAR(255) NULL  ,
   COM_DOCUMENT VARCHAR(255) NULL  ,
   COM_PUBLIC BOOL NOT NULL  ,
   COM_ARCHIVE BOOL NOT NULL  
   , PRIMARY KEY (COM_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_COMPTE_RENDU
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_COMPTE_RENDU_TD_TYPE_COMPTE_RENDU
     ON TD_COMPTE_RENDU (TYC_ID ASC);

CREATE  INDEX I_FK_TD_COMPTE_RENDU_TD_PERSONNE
     ON TD_COMPTE_RENDU (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_TYPE_BDE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_TYPE_BDE
 (
   TYB_ID CHAR(32) NOT NULL  ,
   TYB_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (TYB_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_PROMO
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_PROMO
 (
   PRO_ID CHAR(32) NOT NULL  ,
   PRO_DATE_DEBUT DATE NOT NULL  ,
   PRO_DATE_FIN DATE NOT NULL  
   , PRIMARY KEY (PRO_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_PIECE_JOINTE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_PIECE_JOINTE
 (
   PJ_ID BIGINT(4) NOT NULL  ,
   PJ_NOM_FICHIER CHAR(255) NULL  ,
   PJ_CHEMIN TEXT NULL  ,
   PJ_MIME_TYPE CHAR(100) NULL  ,
   PJ_TAILLE_OCTET BIGINT(10) NULL  ,
   PJ_DATE_DEPOT CHAR(32) NULL  
   , PRIMARY KEY (PJ_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_EVENEMENT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_EVENEMENT
 (
   ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   NOM CHAR(32) NULL  ,
   DESCRIPTION CHAR(32) NULL  ,
   VILLE CHAR(32) NULL  ,
   ADRESSE CHAR(32) NULL  ,
   CODE_POSTAL CHAR(32) NULL  ,
   DATE DATETIME NULL  
   , PRIMARY KEY (ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_EVENEMENT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_EVENEMENT_TD_PERSONNE
     ON TD_EVENEMENT (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_REPRESENTANT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_REPRESENTANT
 (
   PER_ID CHAR(32) NOT NULL  ,
   ENT_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_REPRESENTANT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_REPRESENTANT_TD_ENTREPRISE
     ON TD_REPRESENTANT (ENT_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_ETUDIANT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ETUDIANT
 (
   PER_ID CHAR(32) NOT NULL  ,
   GRP_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_ETUDIANT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_ETUDIANT_TD_GROUPE
     ON TD_ETUDIANT (GRP_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_ECOLE_SUP
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ECOLE_SUP
 (
   ECO_ID CHAR(32) NOT NULL  ,
   ECO_NOM CHAR(32) NOT NULL  ,
   ECO_VILLE CHAR(32) NOT NULL  ,
   ECO_ADRESSE CHAR(32) NOT NULL  ,
   ECO_CODE_POSTAL CHAR(32) NOT NULL  ,
   ECO_MAIL CHAR(32) NOT NULL  ,
   ECO_TELEPHONE CHAR(32) NOT NULL  ,
   ECO_DESCRIPTION CHAR(32) NULL  
   , PRIMARY KEY (ECO_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_GRAVITE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_GRAVITE
 (
   GRA_ID CHAR(32) NOT NULL  ,
   GRA_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (GRA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_JOURNAL_DECISION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_JOURNAL_DECISION
 (
   JDE_DATE_MODIF DATETIME NOT NULL  ,
   DEC_ID CHAR(32) NOT NULL  ,
   JDE_NOM CHAR(32) NOT NULL  ,
   JDE_DATE DATETIME NOT NULL  ,
   JDE_DESCRIPTION CHAR(32) NULL  ,
   JDE_DOCUMENT VARCHAR(255) NULL  ,
   JDE_PUBLIC BOOL NOT NULL  ,
   JDE_ARCHIVE BOOL NOT NULL  ,
   JDE_TYPE CHAR(32) NOT NULL  ,
   JDE_AUTEUR CHAR(32) NOT NULL  
   , PRIMARY KEY (JDE_DATE_MODIF) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_JOURNAL_DECISION
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_JOURNAL_DECISION_TD_DECISION
     ON TD_JOURNAL_DECISION (DEC_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_JOURNAL_COMPTE_RENDU
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_JOURNAL_COMPTE_RENDU
 (
   JCR_DATE_MODIF DATETIME NOT NULL  ,
   COM_ID CHAR(32) NOT NULL  ,
   JCR_ORDRE CHAR(32) NOT NULL  ,
   JCR_DATE DATETIME NOT NULL  ,
   JCR_DESCRIPTION CHAR(32) NULL  ,
   JCR_DOCUMENT CHAR(32) NULL  ,
   JCR_PUBLIC BOOL NOT NULL  ,
   JCR_ARCHIVE BOOL NOT NULL  ,
   JCR_TYPE CHAR(32) NULL  ,
   JCR_AUTEUR CHAR(32) NOT NULL  
   , PRIMARY KEY (JCR_DATE_MODIF) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_JOURNAL_COMPTE_RENDU
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_JOURNAL_COMPTE_RENDU_TD_COMPTE_RENDU
     ON TD_JOURNAL_COMPTE_RENDU (COM_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_PAIEMENT_VACATAIRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_PAIEMENT_VACATAIRE
 (
   PAI_MOIS DATE NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   PAI_DATE_PAIEMENT DATE NULL  ,
   PAI_STATUT CHAR(32) NULL  ,
   PAI_MONTANT BIGINT(4) NOT NULL  
   , PRIMARY KEY (PAI_MOIS) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_PAIEMENT_VACATAIRE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_PAIEMENT_VACATAIRE_TD_VACATAIRE
     ON TD_PAIEMENT_VACATAIRE (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_VACATAIRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_VACATAIRE
 (
   PER_ID CHAR(32) NOT NULL  ,
   VAC_STATUT_PRO CHAR(32) NOT NULL  ,
   VAC_TAUX_HORAIRE DECIMAL(10,2) NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_RDV_SSE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_RDV_SSE
 (
   RDV_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   PER_ID_1 CHAR(32) NOT NULL  ,
   RDV_DATE_DEBUT CHAR(32) NOT NULL  ,
   RDV_DATE_FIN CHAR(32) NOT NULL  ,
   RDV_STATUT CHAR(32) NOT NULL  
   , PRIMARY KEY (RDV_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_RDV_SSE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_RDV_SSE_TD_PERSONNE
     ON TD_RDV_SSE (PER_ID ASC);

CREATE  INDEX I_FK_TD_RDV_SSE_TD_ETUDIANT
     ON TD_RDV_SSE (PER_ID_1 ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_FICHE_PARCOURSUP
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_FICHE_PARCOURSUP
 (
   FPS_ANNEE CHAR(32) NOT NULL  ,
   FPS_FICHE2 CHAR(32) NULL  ,
   FPS_FICHE3 CHAR(32) NULL  
   , PRIMARY KEY (FPS_ANNEE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_TYPE_EVAL
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_TYPE_EVAL
 (
   TYE_ID CHAR(32) NOT NULL  ,
   TYE_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (TYE_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_ABSENCE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ABSENCE
 (
   ABS_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   ABS_DATE_DEBUT DATETIME NOT NULL  ,
   ABS_DATE_FIN DATETIME NOT NULL  ,
   ABS_JUSTIFICATIF VARCHAR(255) NULL  ,
   ABS_STATUT CHAR(32) NOT NULL  
   , PRIMARY KEY (ABS_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_ABSENCE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_ABSENCE_TD_ETUDIANT
     ON TD_ABSENCE (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_QUESTION_AMBASSADEUR
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_QUESTION_AMBASSADEUR
 (
   QUA_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   PER_ID_1 CHAR(32) NOT NULL  ,
   QUA_OBJET CHAR(32) NOT NULL  ,
   QUA_MESSAGE VARCHAR(255) NOT NULL  ,
   QUA_REPONSE VARCHAR(255) NULL  
   , PRIMARY KEY (QUA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_QUESTION_AMBASSADEUR
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_QUESTION_AMBASSADEUR_AMBASSADEUR
     ON TD_QUESTION_AMBASSADEUR (PER_ID_1 ASC);

CREATE  INDEX I_FK_TD_QUESTION_AMBASSADEUR_TD_ETUDIANT
     ON TD_QUESTION_AMBASSADEUR (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : AMBASSADEUR
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS AMBASSADEUR
 (
   PER_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_SANCTION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_SANCTION
 (
   SAN_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   GRA_ID CHAR(32) NOT NULL  ,
   SAN_DATE DATETIME NOT NULL  ,
   SAN_STATUT CHAR(32) NOT NULL  
   , PRIMARY KEY (SAN_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_SANCTION
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_SANCTION_TD_PERSONNE
     ON TD_SANCTION (PER_ID ASC);

CREATE  INDEX I_FK_TD_SANCTION_TD_GRAVITE
     ON TD_SANCTION (GRA_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_GROUPE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_GROUPE
 (
   GRP_ID CHAR(32) NOT NULL  ,
   PRO_ID CHAR(32) NOT NULL  ,
   GRP_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (GRP_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_GROUPE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_GROUPE_TD_PROMO
     ON TD_GROUPE (PRO_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_ENSEIGNANT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ENSEIGNANT
 (
   PER_ID CHAR(32) NOT NULL  ,
   ENS_DATE_EMBAUCHE DATE NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_ETAPE_CHECKLIST
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ETAPE_CHECKLIST
 (
   ETA_ID CHAR(32) NOT NULL  ,
   ETA_LIBELLE CHAR(32) NOT NULL  ,
   ETA_DESCRIPTION VARCHAR(255) NOT NULL  
   , PRIMARY KEY (ETA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_EVALUATION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_EVALUATION
 (
   EVA_ID CHAR(32) NOT NULL  ,
   PRO_ID CHAR(32) NOT NULL  ,
   MAT_ID CHAR(32) NOT NULL  ,
   TYE_ID CHAR(32) NOT NULL  ,
   EVA_DATE DATETIME NOT NULL  ,
   EVA_SALLE CHAR(32) NOT NULL  
   , PRIMARY KEY (EVA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_EVALUATION
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_EVALUATION_TD_PROMO
     ON TD_EVALUATION (PRO_ID ASC);

CREATE  INDEX I_FK_TD_EVALUATION_TD_MATIERE
     ON TD_EVALUATION (MAT_ID ASC);

CREATE  INDEX I_FK_TD_EVALUATION_TD_TYPE_EVAL
     ON TD_EVALUATION (TYE_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_HEURE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_HEURE
 (
   HEU_NUM INTEGER(2) NOT NULL  ,
   MAT_ID CHAR(32) NOT NULL  ,
   HEU_STATUT CHAR(32) NOT NULL  ,
   HEU_DATE_DEBUT DATETIME NOT NULL  ,
   HEU_DATE_FIN DATETIME NOT NULL  
   , PRIMARY KEY (HEU_NUM) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_HEURE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_HEURE_TD_MATIERE
     ON TD_HEURE (MAT_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_STAGIAIRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_STAGIAIRE
 (
   PER_ID CHAR(32) NOT NULL  ,
   PER_ID_1 CHAR(32) NOT NULL  ,
   PER_ID_2 CHAR(32) NOT NULL  ,
   STA_CONVENTION VARCHAR(255) NOT NULL  ,
   STA_STATUT CHAR(32) NOT NULL  ,
   STA_DATE_DEBUT DATE NOT NULL  ,
   STA_DATE_FIN DATE NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_STAGIAIRE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_STAGIAIRE_TD_REPRESENTANT
     ON TD_STAGIAIRE (PER_ID_2 ASC);

CREATE  INDEX I_FK_TD_STAGIAIRE_TD_ENSEIGNANT
     ON TD_STAGIAIRE (PER_ID_1 ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_ADMINISTRATION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ADMINISTRATION
 (
   PER_ID CHAR(32) NOT NULL  ,
   ADM_DATE_EMBAUCHE DATE NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_DOSSIER_VACATAIRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_DOSSIER_VACATAIRE
 (
   DOV_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   DOV_STATUT CHAR(32) NOT NULL  ,
   DOV_CARTEID VARCHAR(255) NOT NULL  ,
   DOV_CV VARCHAR(255) NOT NULL  
   , PRIMARY KEY (DOV_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_DOSSIER_VACATAIRE
# -----------------------------------------------------------------------------


CREATE UNIQUE INDEX I_FK_TD_DOSSIER_VACATAIRE_TD_VACATAIRE
     ON TD_DOSSIER_VACATAIRE (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_ENTREPRISE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ENTREPRISE
 (
   ENT_ID CHAR(32) NOT NULL  ,
   ENT_NOM CHAR(32) NOT NULL  ,
   ENT_TELEPHONE CHAR(10) NULL  ,
   ENT_VILLE CHAR(32) NOT NULL  ,
   ENT_ADRESSE VARCHAR(255) NOT NULL  ,
   ENT_CODE_POSTAL CHAR(5) NOT NULL  ,
   ENT_REGLEMENT_INTERIEUR VARCHAR(255) NOT NULL  
   , PRIMARY KEY (ENT_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_MATIERE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_MATIERE
 (
   MAT_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   MAT_NOM CHAR(32) NOT NULL  ,
   MAT_NB_HEURE INTEGER(2) NOT NULL  
   , PRIMARY KEY (MAT_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_MATIERE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_MATIERE_TD_ENSEIGNANT
     ON TD_MATIERE (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_TYPE_COMPTE_RENDU
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_TYPE_COMPTE_RENDU
 (
   TYC_ID CHAR(32) NOT NULL  ,
   TYC_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (TYC_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_ROLE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ROLE
 (
   ROL_ID CHAR(32) NOT NULL  ,
   ROL_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (ROL_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_QUESTION_DOCINFO
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_QUESTION_DOCINFO
 (
   QDI_ID CHAR(32) NOT NULL  ,
   SUJ_ID CHAR(32) NOT NULL  ,
   QDI_NOM CHAR(32) NOT NULL  ,
   QDI_PRENOM CHAR(32) NOT NULL  ,
   QDI_MAIL CHAR(32) NOT NULL  ,
   QDI_MESSAGE VARCHAR(255) NOT NULL  ,
   QDI_STATUT CHAR(32) NOT NULL  ,
   QDI_REPONSE VARCHAR(255) NULL  
   , PRIMARY KEY (QDI_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_QUESTION_DOCINFO
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_QUESTION_DOCINFO_TD_SUJET_QUESTION
     ON TD_QUESTION_DOCINFO (SUJ_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_TYPE_DECISION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_TYPE_DECISION
 (
   TYD_ID CHAR(32) NOT NULL  ,
   TYD_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (TYD_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_TEMPLATE_MAIL
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_TEMPLATE_MAIL
 (
   TEM_NUM INTEGER(4) NOT NULL  ,
   TEM_OBJET CHAR(32) NULL  ,
   TEM_CORPS TEXT NULL  
   , PRIMARY KEY (TEM_NUM) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_AMENAGEMENT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_AMENAGEMENT
 (
   AME_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   AME_LIBELLE CHAR(32) NOT NULL  ,
   AME_STATUT CHAR(32) NOT NULL  
   , PRIMARY KEY (AME_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_AMENAGEMENT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_AMENAGEMENT_TD_ETUDIANT
     ON TD_AMENAGEMENT (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_APPRENTI
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_APPRENTI
 (
   PER_ID CHAR(32) NOT NULL  ,
   PER_ID_1 CHAR(32) NOT NULL  ,
   PER_ID_2 CHAR(32) NOT NULL  ,
   APP_CONTRAT VARCHAR(255) NOT NULL  ,
   APP_STATUT CHAR(32) NOT NULL  ,
   APP_RESULTAT CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_APPRENTI
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_APPRENTI_TD_ENSEIGNANT
     ON TD_APPRENTI (PER_ID_1 ASC);

CREATE  INDEX I_FK_TD_APPRENTI_TD_REPRESENTANT
     ON TD_APPRENTI (PER_ID_2 ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_CROUS_FERMETURE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_CROUS_FERMETURE
 (
   CRO_DATE DATETIME NOT NULL  ,
   CRO_STATUT CHAR(32) NOT NULL  ,
   CRO_RAISON VARCHAR(255) NULL  
   , PRIMARY KEY (CRO_DATE) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_INFO_BDE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_INFO_BDE
 (
   BDE_ID CHAR(32) NOT NULL  ,
   TYB_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   BDE_TITRE CHAR(32) NOT NULL  ,
   BDE_DESCRIPTION CHAR(32) NULL  
   , PRIMARY KEY (BDE_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_INFO_BDE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_INFO_BDE_TD_ETUDIANT
     ON TD_INFO_BDE (PER_ID ASC);

CREATE  INDEX I_FK_TD_INFO_BDE_TD_TYPE_BDE
     ON TD_INFO_BDE (TYB_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_SUJET_QUESTION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_SUJET_QUESTION
 (
   SUJ_ID CHAR(32) NOT NULL  ,
   SUJ_LIBELLE CHAR(32) NOT NULL  
   , PRIMARY KEY (SUJ_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_KEYWORD
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_KEYWORD
 (
   KEY_ID CHAR(32) NOT NULL  ,
   KEY_WORD CHAR(32) NOT NULL  
   , PRIMARY KEY (KEY_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_DECISION
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_DECISION
 (
   DEC_ID CHAR(32) NOT NULL  ,
   COM_ID CHAR(32) NOT NULL  ,
   TYD_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   DEC_NOM CHAR(32) NOT NULL  ,
   DEC_DATE DATETIME NOT NULL  ,
   DEC_DESCRIPTION VARCHAR(255) NULL  ,
   DEC_DOCUMENT VARCHAR(255) NULL  ,
   DEC_PUBLIC BOOL NOT NULL  ,
   DEC_ARCHIVE BOOL NOT NULL  
   , PRIMARY KEY (DEC_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_DECISION
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_DECISION_TD_COMPTE_RENDU
     ON TD_DECISION (COM_ID ASC);

CREATE  INDEX I_FK_TD_DECISION_TD_TYPE_DECISION
     ON TD_DECISION (TYD_ID ASC);

CREATE  INDEX I_FK_TD_DECISION_TD_PERSONNE
     ON TD_DECISION (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_PERSONNE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_PERSONNE
 (
   PER_ID CHAR(32) NOT NULL  ,
   PER_PASSWORD CHAR(255) NOT NULL  ,
   PER_NOM CHAR(32) NOT NULL  ,
   PER_PRENOM CHAR(32) NOT NULL  ,
   PER_VILLE_NAISSANCE CHAR(32) NOT NULL  ,
   PER_DATE_NAISSANCE DATE NOT NULL  ,
   PER_MAIL CHAR(32) NOT NULL  ,
   PER_TELEPHONE CHAR(10) NULL  
   , PRIMARY KEY (PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       TABLE : TD_ATTRIBUE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_ATTRIBUE
 (
   PER_ID CHAR(32) NOT NULL  ,
   ROL_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID,ROL_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_ATTRIBUE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_ATTRIBUE_TD_PERSONNE
     ON TD_ATTRIBUE (PER_ID ASC);

CREATE  INDEX I_FK_TD_ATTRIBUE_TD_ROLE
     ON TD_ATTRIBUE (ROL_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_JOINDRE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_JOINDRE
 (
   TEM_NUM INTEGER(4) NOT NULL  ,
   PJ_ID BIGINT(4) NOT NULL  
   , PRIMARY KEY (TEM_NUM,PJ_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_JOINDRE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_JOINDRE_TD_TEMPLATE_MAIL
     ON TD_JOINDRE (TEM_NUM ASC);

CREATE  INDEX I_FK_TD_JOINDRE_TD_PIECE_JOINTE
     ON TD_JOINDRE (PJ_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : AMBASSADE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS AMBASSADE
 (
   ECO_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (ECO_ID,PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE AMBASSADE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_AMBASSADE_TD_ECOLE_SUP
     ON AMBASSADE (ECO_ID ASC);

CREATE  INDEX I_FK_AMBASSADE_AMBASSADEUR
     ON AMBASSADE (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : SOUHAIT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS SOUHAIT
 (
   PER_ID CHAR(32) NOT NULL  ,
   ECO_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID,ECO_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE SOUHAIT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_SOUHAIT_TD_ETUDIANT
     ON SOUHAIT (PER_ID ASC);

CREATE  INDEX I_FK_SOUHAIT_TD_ECOLE_SUP
     ON SOUHAIT (ECO_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : INCLUS
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS INCLUS
 (
   ECO_ID CHAR(32) NOT NULL  ,
   KEY_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (ECO_ID,KEY_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE INCLUS
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_INCLUS_TD_ECOLE_SUP
     ON INCLUS (ECO_ID ASC);

CREATE  INDEX I_FK_INCLUS_TD_KEYWORD
     ON INCLUS (KEY_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : INCLURE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS INCLURE
 (
   DEC_ID CHAR(32) NOT NULL  ,
   KEY_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (DEC_ID,KEY_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE INCLURE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_INCLURE_TD_DECISION
     ON INCLURE (DEC_ID ASC);

CREATE  INDEX I_FK_INCLURE_TD_KEYWORD
     ON INCLURE (KEY_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_RESULTAT
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_RESULTAT
 (
   PER_ID CHAR(32) NOT NULL  ,
   EVA_ID CHAR(32) NOT NULL  ,
   RES_NOTE CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID,EVA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_RESULTAT
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_RESULTAT_TD_ETUDIANT
     ON TD_RESULTAT (PER_ID ASC);

CREATE  INDEX I_FK_TD_RESULTAT_TD_EVALUATION
     ON TD_RESULTAT (EVA_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_JURY
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_JURY
 (
   PER_ID CHAR(32) NOT NULL  ,
   EVA_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (PER_ID,EVA_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_JURY
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_JURY_TD_ENSEIGNANT
     ON TD_JURY (PER_ID ASC);

CREATE  INDEX I_FK_TD_JURY_TD_EVALUATION
     ON TD_JURY (EVA_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : ENSEIGNER
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ENSEIGNER
 (
   MAT_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  ,
   ENS_NB_HEURE_PREVU INTEGER(2) NULL  ,
   NB_HEURE_EFFECTUE INTEGER(2) NULL  
   , PRIMARY KEY (MAT_ID,PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE ENSEIGNER
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_ENSEIGNER_TD_MATIERE
     ON ENSEIGNER (MAT_ID ASC);

CREATE  INDEX I_FK_ENSEIGNER_TD_ENSEIGNANT
     ON ENSEIGNER (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : TD_DESTINER
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS TD_DESTINER
 (
   TEM_NUM INTEGER(4) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (TEM_NUM,PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE TD_DESTINER
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_TD_DESTINER_TD_TEMPLATE_MAIL
     ON TD_DESTINER (TEM_NUM ASC);

CREATE  INDEX I_FK_TD_DESTINER_TD_PERSONNE
     ON TD_DESTINER (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : CONCERNER2
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS CONCERNER2
 (
   SAN_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (SAN_ID,PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE CONCERNER2
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_CONCERNER2_TD_SANCTION
     ON CONCERNER2 (SAN_ID ASC);

CREATE  INDEX I_FK_CONCERNER2_TD_ETUDIANT
     ON CONCERNER2 (PER_ID ASC);

# -----------------------------------------------------------------------------
#       TABLE : PARTICIPE
# -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS PARTICIPE
 (
   REU_ID CHAR(32) NOT NULL  ,
   PER_ID CHAR(32) NOT NULL  
   , PRIMARY KEY (REU_ID,PER_ID) 
 ) 
 comment = "";

# -----------------------------------------------------------------------------
#       INDEX DE LA TABLE PARTICIPE
# -----------------------------------------------------------------------------


CREATE  INDEX I_FK_PARTICIPE_TD_REUNION
     ON PARTICIPE (REU_ID ASC);

CREATE  INDEX I_FK_PARTICIPE_TD_PERSONNE
     ON PARTICIPE (PER_ID ASC);


# -----------------------------------------------------------------------------
#       CREATION DES REFERENCES DE TABLE
# -----------------------------------------------------------------------------


ALTER TABLE TD_CHECKLIST 
  ADD FOREIGN KEY FK_TD_CHECKLIST_TD_VACATAIRE (PER_ID)
      REFERENCES TD_VACATAIRE (PER_ID) ;


ALTER TABLE TD_CHECKLIST 
  ADD FOREIGN KEY FK_TD_CHECKLIST_TD_ETAPE_CHECKLIST (ETA_ID)
      REFERENCES TD_ETAPE_CHECKLIST (ETA_ID) ;


ALTER TABLE TD_COMPTE_RENDU 
  ADD FOREIGN KEY FK_TD_COMPTE_RENDU_TD_TYPE_COMPTE_RENDU (TYC_ID)
      REFERENCES TD_TYPE_COMPTE_RENDU (TYC_ID) ;


ALTER TABLE TD_COMPTE_RENDU 
  ADD FOREIGN KEY FK_TD_COMPTE_RENDU_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_EVENEMENT 
  ADD FOREIGN KEY FK_TD_EVENEMENT_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_REPRESENTANT 
  ADD FOREIGN KEY FK_TD_REPRESENTANT_TD_ENTREPRISE (ENT_ID)
      REFERENCES TD_ENTREPRISE (ENT_ID) ;


ALTER TABLE TD_REPRESENTANT 
  ADD FOREIGN KEY FK_TD_REPRESENTANT_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_ETUDIANT 
  ADD FOREIGN KEY FK_TD_ETUDIANT_TD_GROUPE (GRP_ID)
      REFERENCES TD_GROUPE (GRP_ID) ;


ALTER TABLE TD_ETUDIANT 
  ADD FOREIGN KEY FK_TD_ETUDIANT_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_JOURNAL_DECISION 
  ADD FOREIGN KEY FK_TD_JOURNAL_DECISION_TD_DECISION (DEC_ID)
      REFERENCES TD_DECISION (DEC_ID) ;


ALTER TABLE TD_JOURNAL_COMPTE_RENDU 
  ADD FOREIGN KEY FK_TD_JOURNAL_COMPTE_RENDU_TD_COMPTE_RENDU (COM_ID)
      REFERENCES TD_COMPTE_RENDU (COM_ID) ;


ALTER TABLE TD_PAIEMENT_VACATAIRE 
  ADD FOREIGN KEY FK_TD_PAIEMENT_VACATAIRE_TD_VACATAIRE (PER_ID)
      REFERENCES TD_VACATAIRE (PER_ID) ;


ALTER TABLE TD_VACATAIRE 
  ADD FOREIGN KEY FK_TD_VACATAIRE_TD_ENSEIGNANT (PER_ID)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_RDV_SSE 
  ADD FOREIGN KEY FK_TD_RDV_SSE_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_RDV_SSE 
  ADD FOREIGN KEY FK_TD_RDV_SSE_TD_ETUDIANT (PER_ID_1)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_ABSENCE 
  ADD FOREIGN KEY FK_TD_ABSENCE_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_QUESTION_AMBASSADEUR 
  ADD FOREIGN KEY FK_TD_QUESTION_AMBASSADEUR_AMBASSADEUR (PER_ID_1)
      REFERENCES AMBASSADEUR (PER_ID) ;


ALTER TABLE TD_QUESTION_AMBASSADEUR 
  ADD FOREIGN KEY FK_TD_QUESTION_AMBASSADEUR_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE AMBASSADEUR 
  ADD FOREIGN KEY FK_AMBASSADEUR_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_SANCTION 
  ADD FOREIGN KEY FK_TD_SANCTION_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_SANCTION 
  ADD FOREIGN KEY FK_TD_SANCTION_TD_GRAVITE (GRA_ID)
      REFERENCES TD_GRAVITE (GRA_ID) ;


ALTER TABLE TD_GROUPE 
  ADD FOREIGN KEY FK_TD_GROUPE_TD_PROMO (PRO_ID)
      REFERENCES TD_PROMO (PRO_ID) ;


ALTER TABLE TD_ENSEIGNANT 
  ADD FOREIGN KEY FK_TD_ENSEIGNANT_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_EVALUATION 
  ADD FOREIGN KEY FK_TD_EVALUATION_TD_PROMO (PRO_ID)
      REFERENCES TD_PROMO (PRO_ID) ;


ALTER TABLE TD_EVALUATION 
  ADD FOREIGN KEY FK_TD_EVALUATION_TD_MATIERE (MAT_ID)
      REFERENCES TD_MATIERE (MAT_ID) ;


ALTER TABLE TD_EVALUATION 
  ADD FOREIGN KEY FK_TD_EVALUATION_TD_TYPE_EVAL (TYE_ID)
      REFERENCES TD_TYPE_EVAL (TYE_ID) ;


ALTER TABLE TD_HEURE 
  ADD FOREIGN KEY FK_TD_HEURE_TD_MATIERE (MAT_ID)
      REFERENCES TD_MATIERE (MAT_ID) ;


ALTER TABLE TD_STAGIAIRE 
  ADD FOREIGN KEY FK_TD_STAGIAIRE_TD_REPRESENTANT (PER_ID_2)
      REFERENCES TD_REPRESENTANT (PER_ID) ;


ALTER TABLE TD_STAGIAIRE 
  ADD FOREIGN KEY FK_TD_STAGIAIRE_TD_ENSEIGNANT (PER_ID_1)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_STAGIAIRE 
  ADD FOREIGN KEY FK_TD_STAGIAIRE_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_ADMINISTRATION 
  ADD FOREIGN KEY FK_TD_ADMINISTRATION_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_DOSSIER_VACATAIRE 
  ADD FOREIGN KEY FK_TD_DOSSIER_VACATAIRE_TD_VACATAIRE (PER_ID)
      REFERENCES TD_VACATAIRE (PER_ID) ;


ALTER TABLE TD_MATIERE 
  ADD FOREIGN KEY FK_TD_MATIERE_TD_ENSEIGNANT (PER_ID)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_QUESTION_DOCINFO 
  ADD FOREIGN KEY FK_TD_QUESTION_DOCINFO_TD_SUJET_QUESTION (SUJ_ID)
      REFERENCES TD_SUJET_QUESTION (SUJ_ID) ;


ALTER TABLE TD_AMENAGEMENT 
  ADD FOREIGN KEY FK_TD_AMENAGEMENT_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_APPRENTI 
  ADD FOREIGN KEY FK_TD_APPRENTI_TD_ENSEIGNANT (PER_ID_1)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_APPRENTI 
  ADD FOREIGN KEY FK_TD_APPRENTI_TD_REPRESENTANT (PER_ID_2)
      REFERENCES TD_REPRESENTANT (PER_ID) ;


ALTER TABLE TD_APPRENTI 
  ADD FOREIGN KEY FK_TD_APPRENTI_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_INFO_BDE 
  ADD FOREIGN KEY FK_TD_INFO_BDE_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_INFO_BDE 
  ADD FOREIGN KEY FK_TD_INFO_BDE_TD_TYPE_BDE (TYB_ID)
      REFERENCES TD_TYPE_BDE (TYB_ID) ;


ALTER TABLE TD_DECISION 
  ADD FOREIGN KEY FK_TD_DECISION_TD_COMPTE_RENDU (COM_ID)
      REFERENCES TD_COMPTE_RENDU (COM_ID) ;


ALTER TABLE TD_DECISION 
  ADD FOREIGN KEY FK_TD_DECISION_TD_TYPE_DECISION (TYD_ID)
      REFERENCES TD_TYPE_DECISION (TYD_ID) ;


ALTER TABLE TD_DECISION 
  ADD FOREIGN KEY FK_TD_DECISION_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_ATTRIBUE 
  ADD FOREIGN KEY FK_TD_ATTRIBUE_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE TD_ATTRIBUE 
  ADD FOREIGN KEY FK_TD_ATTRIBUE_TD_ROLE (ROL_ID)
      REFERENCES TD_ROLE (ROL_ID) ;


ALTER TABLE TD_JOINDRE 
  ADD FOREIGN KEY FK_TD_JOINDRE_TD_TEMPLATE_MAIL (TEM_NUM)
      REFERENCES TD_TEMPLATE_MAIL (TEM_NUM) ;


ALTER TABLE TD_JOINDRE 
  ADD FOREIGN KEY FK_TD_JOINDRE_TD_PIECE_JOINTE (PJ_ID)
      REFERENCES TD_PIECE_JOINTE (PJ_ID) ;


ALTER TABLE AMBASSADE 
  ADD FOREIGN KEY FK_AMBASSADE_TD_ECOLE_SUP (ECO_ID)
      REFERENCES TD_ECOLE_SUP (ECO_ID) ;


ALTER TABLE AMBASSADE 
  ADD FOREIGN KEY FK_AMBASSADE_AMBASSADEUR (PER_ID)
      REFERENCES AMBASSADEUR (PER_ID) ;


ALTER TABLE SOUHAIT 
  ADD FOREIGN KEY FK_SOUHAIT_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE SOUHAIT 
  ADD FOREIGN KEY FK_SOUHAIT_TD_ECOLE_SUP (ECO_ID)
      REFERENCES TD_ECOLE_SUP (ECO_ID) ;


ALTER TABLE INCLUS 
  ADD FOREIGN KEY FK_INCLUS_TD_ECOLE_SUP (ECO_ID)
      REFERENCES TD_ECOLE_SUP (ECO_ID) ;


ALTER TABLE INCLUS 
  ADD FOREIGN KEY FK_INCLUS_TD_KEYWORD (KEY_ID)
      REFERENCES TD_KEYWORD (KEY_ID) ;


ALTER TABLE INCLURE 
  ADD FOREIGN KEY FK_INCLURE_TD_DECISION (DEC_ID)
      REFERENCES TD_DECISION (DEC_ID) ;


ALTER TABLE INCLURE 
  ADD FOREIGN KEY FK_INCLURE_TD_KEYWORD (KEY_ID)
      REFERENCES TD_KEYWORD (KEY_ID) ;


ALTER TABLE TD_RESULTAT 
  ADD FOREIGN KEY FK_TD_RESULTAT_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE TD_RESULTAT 
  ADD FOREIGN KEY FK_TD_RESULTAT_TD_EVALUATION (EVA_ID)
      REFERENCES TD_EVALUATION (EVA_ID) ;


ALTER TABLE TD_JURY 
  ADD FOREIGN KEY FK_TD_JURY_TD_ENSEIGNANT (PER_ID)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_JURY 
  ADD FOREIGN KEY FK_TD_JURY_TD_EVALUATION (EVA_ID)
      REFERENCES TD_EVALUATION (EVA_ID) ;


ALTER TABLE ENSEIGNER 
  ADD FOREIGN KEY FK_ENSEIGNER_TD_MATIERE (MAT_ID)
      REFERENCES TD_MATIERE (MAT_ID) ;


ALTER TABLE ENSEIGNER 
  ADD FOREIGN KEY FK_ENSEIGNER_TD_ENSEIGNANT (PER_ID)
      REFERENCES TD_ENSEIGNANT (PER_ID) ;


ALTER TABLE TD_DESTINER 
  ADD FOREIGN KEY FK_TD_DESTINER_TD_TEMPLATE_MAIL (TEM_NUM)
      REFERENCES TD_TEMPLATE_MAIL (TEM_NUM) ;


ALTER TABLE TD_DESTINER 
  ADD FOREIGN KEY FK_TD_DESTINER_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


ALTER TABLE CONCERNER2 
  ADD FOREIGN KEY FK_CONCERNER2_TD_SANCTION (SAN_ID)
      REFERENCES TD_SANCTION (SAN_ID) ;


ALTER TABLE CONCERNER2 
  ADD FOREIGN KEY FK_CONCERNER2_TD_ETUDIANT (PER_ID)
      REFERENCES TD_ETUDIANT (PER_ID) ;


ALTER TABLE PARTICIPE 
  ADD FOREIGN KEY FK_PARTICIPE_TD_REUNION (REU_ID)
      REFERENCES TD_REUNION (REU_ID) ;


ALTER TABLE PARTICIPE 
  ADD FOREIGN KEY FK_PARTICIPE_TD_PERSONNE (PER_ID)
      REFERENCES TD_PERSONNE (PER_ID) ;


SET NAMES utf8mb4;
USE MLR3;

-- =============================================================================
--  JEU DE DONNEES DE DEV - base MLR3 (57 tables)
--  21 roles (ID compose [categorie][role sur 2 chiffres]) x 3 utilisateurs = 63 comptes
--  Mot de passe de test pour tous : Password123!  (stocke en SHA2-256)
--  A executer apres la creation du schema, sur une base VIDE.
--  Date de reference du jeu de donnees : 26/11/2026
-- =============================================================================


-- -----------------------------------------------------------------------------
--  1. REFERENTIELS
-- -----------------------------------------------------------------------------

-- ROL_ID = [categorie][numero du role dans la categorie sur 2 chiffres]
-- Categories : 1 Systeme, 2 Administratif, 3 Administration, 4 Autre, 5 Enseignant, 6 Etudiant, 7 Externe
INSERT INTO TD_ROLE (ROL_ID, ROL_LIBELLE) VALUES
('101', 'Administrateur de la plateforme'),
('201', 'Resp. validation des heures'),
('301', 'Chef de département'),
('302', 'Personnel administratif'),
('303', 'Personnel de la DSI'),
('304', 'Secrétaire de département'),
('305', 'Responsable des vacataires'),
('401', 'Utilisateur connecté'),
('501', 'Directeur des études'),
('502', 'Enseignant titulaire'),
('503', 'Enseignant vacataire'),
('504', 'Responsable de stage enseignant'),
('601', 'Étudiant'),
('602', 'Étudiant apprenti'),
('603', 'Étudiant BDE'),
('604', 'Étudiant élu'),
('701', 'Étudiant Ambassadeur'),
('702', 'Personnel CROUS'),
('703', 'Personnel SSE'),
('704', 'Utilisateur non connecté'),
('705', 'Responsable entreprise stage');

-- PRO_ID = BUINFO[annee 1 a 3]A
INSERT INTO TD_PROMO (PRO_ID, PRO_DATE_DEBUT, PRO_DATE_FIN) VALUES
('BUINFO1A', '2026-09-01', '2027-06-30'),
('BUINFO2A', '2026-09-01', '2027-06-30'),
('BUINFO3A', '2026-09-01', '2027-06-30');

-- GRP_ID = TD[numero de TD][numero de TP], ex. TD21 = TD 2, TP 1
INSERT INTO TD_GROUPE (GRP_ID, PRO_ID, GRP_LIBELLE) VALUES
('TD11', 'BUINFO1A', 'TD1 - TP1'),
('TD12', 'BUINFO1A', 'TD1 - TP2'),
('TD21', 'BUINFO1A', 'TD2 - TP1');

INSERT INTO TD_ENTREPRISE (ENT_ID, ENT_NOM, ENT_TELEPHONE, ENT_VILLE, ENT_ADRESSE, ENT_CODE_POSTAL, ENT_REGLEMENT_INTERIEUR) VALUES
('ENT_01', 'Norman Tech', '0231000001', 'Caen', '12 rue des Quais', '14000', 'reglement_norman_tech.pdf'),
('ENT_02', 'Calvados Data', '0231000002', 'Caen', '5 avenue de la Liberte', '14000', 'reglement_calvados_data.pdf'),
('ENT_03', 'Cotentin Soft', '0233000003', 'Cherbourg', '8 quai de Caligny', '50100', 'reglement_cotentin_soft.pdf'),
('ENT_04', 'Rouen Digital', '0235000004', 'Rouen', '27 rue Jeanne d Arc', '76000', 'reglement_rouen_digital.pdf'),
('ENT_05', 'Manche Cyber', '0233000005', 'Saint-Lo', '3 place du Champ de Mars', '50000', 'reglement_manche_cyber.pdf');

INSERT INTO TD_TYPE_EVAL (TYE_ID, TYE_LIBELLE) VALUES
('TYE_01', 'Controle continu'),
('TYE_02', 'Examen final'),
('TYE_03', 'TP note'),
('TYE_04', 'Projet'),
('TYE_05', 'Oral');

INSERT INTO TD_TYPE_BDE (TYB_ID, TYB_LIBELLE) VALUES
('TYB_01', 'Evenement'),
('TYB_02', 'Annonce'),
('TYB_03', 'Partenariat'),
('TYB_04', 'Soiree');

INSERT INTO TD_GRAVITE (GRA_ID, GRA_LIBELLE) VALUES
('GRA_1', 'Mineure'),
('GRA_2', 'Moderee'),
('GRA_3', 'Grave'),
('GRA_4', 'Tres grave');

INSERT INTO TD_TYPE_COMPTE_RENDU (TYC_ID, TYC_LIBELLE) VALUES
('TYC_01', 'Reunion pedagogique'),
('TYC_02', 'Conseil de classe'),
('TYC_03', 'Jury'),
('TYC_04', 'Reunion administrative');

INSERT INTO TD_TYPE_DECISION (TYD_ID, TYD_LIBELLE) VALUES
('TYD_01', 'Validation'),
('TYD_02', 'Avertissement'),
('TYD_03', 'Redoublement'),
('TYD_04', 'Admission'),
('TYD_05', 'Amenagement');

INSERT INTO TD_SUJET_QUESTION (SUJ_ID, SUJ_LIBELLE) VALUES
('SUJ_01', 'Admission'),
('SUJ_02', 'Scolarite'),
('SUJ_03', 'Alternance'),
('SUJ_04', 'Vie etudiante'),
('SUJ_05', 'Autre');

INSERT INTO TD_KEYWORD (KEY_ID, KEY_WORD) VALUES
('KEY_01', 'informatique'),
('KEY_02', 'cybersecurite'),
('KEY_03', 'data'),
('KEY_04', 'reseaux'),
('KEY_05', 'ingenieur'),
('KEY_06', 'alternance'),
('KEY_07', 'master'),
('KEY_08', 'recherche'),
('KEY_09', 'international'),
('KEY_10', 'developpement');

INSERT INTO TD_ETAPE_CHECKLIST (ETA_ID, ETA_LIBELLE, ETA_DESCRIPTION) VALUES
('ETA_01', 'Piece d identite', 'Fournir une copie recto-verso de la carte d identite ou du passeport.'),
('ETA_02', 'CV a jour', 'Deposer un CV de moins de 6 mois.'),
('ETA_03', 'RIB', 'Fournir un RIB au nom du vacataire pour le paiement.'),
('ETA_04', 'Contrat signe', 'Retourner le contrat de vacation signe.'),
('ETA_05', 'Attestation employeur', 'Autorisation de cumul pour les vacataires salaries.');


-- -----------------------------------------------------------------------------
--  2. PERSONNES ET ROLES (3 par role)
-- -----------------------------------------------------------------------------

-- 101  Système / Administrateur de la plateforme
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_SYS_01', SHA2('Password123!',256), 'Martin', 'Claire', 'Caen', '1969-12-30', 'claire.martin@univ-caen.fr', '0600000001'),
('PER_SYS_02', SHA2('Password123!',256), 'Bernard', 'Thomas', 'Lisieux', '1977-05-04', 'thomas.bernard@univ-caen.fr', '0600000002'),
('PER_SYS_03', SHA2('Password123!',256), 'Petit', 'Sophie', 'Bayeux', '1975-01-06', 'sophie.petit@univ-caen.fr', '0600000003');

-- 201  Administratif / Resp. validation des heures
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_RVH_01', SHA2('Password123!',256), 'Durand', 'Jean', 'Deauville', '1969-08-07', 'jean.durand@univ-caen.fr', '0600000004'),
('PER_RVH_02', SHA2('Password123!',256), 'Leroy', 'Isabelle', 'Rouen', '1989-06-19', 'isabelle.leroy@univ-caen.fr', '0600000005'),
('PER_RVH_03', SHA2('Password123!',256), 'Moreau', 'Marc', 'Evreux', '1991-06-28', 'marc.moreau@univ-caen.fr', '0600000006');

-- 301  Administration / Chef de département
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_CHD_01', SHA2('Password123!',256), 'Simon', 'Laurent', 'Caen', '1966-06-05', 'laurent.simon@univ-caen.fr', '0600000007'),
('PER_CHD_02', SHA2('Password123!',256), 'Laurent', 'Nathalie', 'Lisieux', '1969-03-16', 'nathalie.laurent@univ-caen.fr', '0600000008'),
('PER_CHD_03', SHA2('Password123!',256), 'Lefebvre', 'Olivier', 'Cherbourg', '1975-06-09', 'olivier.lefebvre@univ-caen.fr', '0600000009');

-- 302  Administration / Personnel administratif
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_PAD_01', SHA2('Password123!',256), 'Garcia', 'Julien', 'Cherbourg', '1966-03-11', 'julien.garcia@univ-caen.fr', '0600000010'),
('PER_PAD_02', SHA2('Password123!',256), 'Roux', 'Camille', 'Saint-Lo', '1973-12-02', 'camille.roux@univ-caen.fr', '0600000011'),
('PER_PAD_03', SHA2('Password123!',256), 'Fournier', 'Antoine', 'Evreux', '1989-06-12', 'antoine.fournier@univ-caen.fr', '0600000012');

-- 303  Administration / Personnel de la DSI
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_DSI_01', SHA2('Password123!',256), 'Girard', 'Lucas', 'Falaise', '1974-11-21', 'lucas.girard@univ-caen.fr', '0600000013'),
('PER_DSI_02', SHA2('Password123!',256), 'Bonnet', 'Emma', 'Vire', '1991-06-08', 'emma.bonnet@univ-caen.fr', '0600000014'),
('PER_DSI_03', SHA2('Password123!',256), 'Dupuis', 'Hugo', 'Cabourg', '1965-04-17', 'hugo.dupuis@univ-caen.fr', '0600000015');

-- 304  Administration / Secrétaire de département
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_SEC_01', SHA2('Password123!',256), 'Lambert', 'Lea', 'Saint-Lo', '1972-02-29', 'lea.lambert@univ-caen.fr', '0600000016'),
('PER_SEC_02', SHA2('Password123!',256), 'Fontaine', 'Nathan', 'Alencon', '1983-12-17', 'nathan.fontaine@univ-caen.fr', '0600000017'),
('PER_SEC_03', SHA2('Password123!',256), 'Rousseau', 'Chloe', 'Bayeux', '1977-06-19', 'chloe.rousseau@univ-caen.fr', '0600000018');

-- 305  Administration / Responsable des vacataires
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_RVC_01', SHA2('Password123!',256), 'Vincent', 'Maxime', 'Cabourg', '1974-08-29', 'maxime.vincent@univ-caen.fr', '0600000019'),
('PER_RVC_02', SHA2('Password123!',256), 'Muller', 'Manon', 'Rouen', '1980-02-06', 'manon.muller@univ-caen.fr', '0600000020'),
('PER_RVC_03', SHA2('Password123!',256), 'Faure', 'Alexandre', 'Evreux', '1969-02-28', 'alexandre.faure@univ-caen.fr', '0600000021');

-- 401  Autre / Utilisateur connecté
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_UCO_01', SHA2('Password123!',256), 'Andre', 'Sarah', 'Alencon', '1969-05-04', 'sarah.andre@mail.fr', '0600000022'),
('PER_UCO_02', SHA2('Password123!',256), 'Mercier', 'Paul', 'Honfleur', '1980-06-06', 'paul.mercier@mail.fr', '0600000023'),
('PER_UCO_03', SHA2('Password123!',256), 'Blanc', 'Ines', 'Cabourg', '1976-11-12', 'ines.blanc@mail.fr', '0600000024');

-- 501  Enseignant / Directeur des études
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_DET_01', SHA2('Password123!',256), 'Guerin', 'Pierre', 'Saint-Lo', '1966-12-13', 'pierre.guerin@univ-caen.fr', '0600000025'),
('PER_DET_02', SHA2('Password123!',256), 'Boyer', 'Marie', 'Cherbourg', '1985-08-11', 'marie.boyer@univ-caen.fr', '0600000026'),
('PER_DET_03', SHA2('Password123!',256), 'Garnier', 'Nicolas', 'Evreux', '1970-08-08', 'nicolas.garnier@univ-caen.fr', '0600000027');

-- 502  Enseignant / Enseignant titulaire
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_TIT_01', SHA2('Password123!',256), 'Chevalier', 'Julie', 'Cherbourg', '1968-07-15', 'julie.chevalier@univ-caen.fr', '0600000028'),
('PER_TIT_02', SHA2('Password123!',256), 'Legrand', 'David', 'Coutances', '1978-02-25', 'david.legrand@univ-caen.fr', '0600000029'),
('PER_TIT_03', SHA2('Password123!',256), 'Gauthier', 'Celine', 'Honfleur', '1981-03-23', 'celine.gauthier@univ-caen.fr', '0600000030');

-- 503  Enseignant / Enseignant vacataire
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_VAC_01', SHA2('Password123!',256), 'Perrin', 'Francois', 'Saint-Lo', '1973-08-17', 'francois.perrin@mail.fr', '0600000031'),
('PER_VAC_02', SHA2('Password123!',256), 'Robin', 'Anne', 'Caen', '1968-02-14', 'anne.robin@mail.fr', '0600000032'),
('PER_VAC_03', SHA2('Password123!',256), 'Clement', 'Eric', 'Cabourg', '1975-03-23', 'eric.clement@mail.fr', '0600000033');

-- 504  Enseignant / Responsable de stage enseignant
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_RST_01', SHA2('Password123!',256), 'Morin', 'Sandrine', 'Rouen', '1977-12-25', 'sandrine.morin@univ-caen.fr', '0600000034'),
('PER_RST_02', SHA2('Password123!',256), 'Nicolas', 'Pascal', 'Coutances', '1975-06-12', 'pascal.nicolas@univ-caen.fr', '0600000035'),
('PER_RST_03', SHA2('Password123!',256), 'Henry', 'Valerie', 'Evreux', '1969-07-13', 'valerie.henry@univ-caen.fr', '0600000036');

-- 601  Étudiant / Étudiant
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_ETU_01', SHA2('Password123!',256), 'Roussel', 'Stephane', 'Falaise', '2004-07-23', 'stephane.roussel@etu.unicaen.fr', '0600000037'),
('PER_ETU_02', SHA2('Password123!',256), 'Mathieu', 'Laura', 'Coutances', '2006-07-25', 'laura.mathieu@etu.unicaen.fr', '0600000038'),
('PER_ETU_03', SHA2('Password123!',256), 'Masson', 'Kevin', 'Bayeux', '2005-01-17', 'kevin.masson@etu.unicaen.fr', '0600000039');

-- 602  Étudiant / Étudiant apprenti
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_APP_01', SHA2('Password123!',256), 'Marchand', 'Pauline', 'Alencon', '2005-01-28', 'pauline.marchand@etu.unicaen.fr', '0600000040'),
('PER_APP_02', SHA2('Password123!',256), 'Duval', 'Romain', 'Deauville', '2004-03-05', 'romain.duval@etu.unicaen.fr', '0600000041'),
('PER_APP_03', SHA2('Password123!',256), 'Denis', 'Elodie', 'Saint-Lo', '2004-06-30', 'elodie.denis@etu.unicaen.fr', '0600000042');

-- 603  Étudiant / Étudiant BDE
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_BDE_01', SHA2('Password123!',256), 'Dumont', 'Mathieu', 'Deauville', '2006-10-31', 'mathieu.dumont@etu.unicaen.fr', '0600000043'),
('PER_BDE_02', SHA2('Password123!',256), 'Lemaire', 'Aurelie', 'Honfleur', '2003-05-27', 'aurelie.lemaire@etu.unicaen.fr', '0600000044'),
('PER_BDE_03', SHA2('Password123!',256), 'Noel', 'Quentin', 'Bayeux', '2006-07-24', 'quentin.noel@etu.unicaen.fr', '0600000045');

-- 604  Étudiant / Étudiant élu
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_ELU_01', SHA2('Password123!',256), 'Meyer', 'Justine', 'Saint-Lo', '2005-12-29', 'justine.meyer@etu.unicaen.fr', '0600000046'),
('PER_ELU_02', SHA2('Password123!',256), 'Dufour', 'Adrien', 'Bayeux', '2004-05-16', 'adrien.dufour@etu.unicaen.fr', '0600000047'),
('PER_ELU_03', SHA2('Password123!',256), 'Meunier', 'Marine', 'Evreux', '2005-08-04', 'marine.meunier@etu.unicaen.fr', '0600000048');

-- 701  Externe / Étudiant Ambassadeur
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_AMB_01', SHA2('Password123!',256), 'Brun', 'Theo', 'Deauville', '2004-07-06', 'theo.brun@etu.unicaen.fr', '0600000049'),
('PER_AMB_02', SHA2('Password123!',256), 'Blanchard', 'Clara', 'Cherbourg', '2006-11-10', 'clara.blanchard@etu.unicaen.fr', '0600000050'),
('PER_AMB_03', SHA2('Password123!',256), 'Giraud', 'Louis', 'Deauville', '2004-03-25', 'louis.giraud@etu.unicaen.fr', '0600000051');

-- 702  Externe / Personnel CROUS
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_CRO_01', SHA2('Password123!',256), 'Joly', 'Alice', 'Coutances', '1979-07-20', 'alice.joly@crous-normandie.fr', '0600000052'),
('PER_CRO_02', SHA2('Password123!',256), 'Riviere', 'Jules', 'Lisieux', '1967-07-06', 'jules.riviere@crous-normandie.fr', '0600000053'),
('PER_CRO_03', SHA2('Password123!',256), 'Lucas', 'Lena', 'Cabourg', '1966-06-10', 'lena.lucas@crous-normandie.fr', '0600000054');

-- 703  Externe / Personnel SSE
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_SSE_01', SHA2('Password123!',256), 'Brunet', 'Arthur', 'Evreux', '1979-02-25', 'arthur.brunet@univ-caen.fr', '0600000055'),
('PER_SSE_02', SHA2('Password123!',256), 'Gaillard', 'Zoe', 'Rouen', '1977-01-04', 'zoe.gaillard@univ-caen.fr', '0600000056'),
('PER_SSE_03', SHA2('Password123!',256), 'Barbier', 'Victor', 'Honfleur', '1974-06-19', 'victor.barbier@univ-caen.fr', '0600000057');

-- 704  Externe / Utilisateur non connecté
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_UNC_01', SHA2('Password123!',256), 'Arnaud', 'Margaux', 'Lisieux', '1979-02-12', 'margaux.arnaud@mail.fr', '0600000058'),
('PER_UNC_02', SHA2('Password123!',256), 'Martinez', 'Gabriel', 'Evreux', '1987-05-25', 'gabriel.martinez@mail.fr', '0600000059'),
('PER_UNC_03', SHA2('Password123!',256), 'Gerard', 'Eva', 'Bayeux', '1985-08-01', 'eva.gerard@mail.fr', '0600000060');

-- 705  Externe / Responsable entreprise stage
INSERT INTO TD_PERSONNE (PER_ID, PER_PASSWORD, PER_NOM, PER_PRENOM, PER_VILLE_NAISSANCE, PER_DATE_NAISSANCE, PER_MAIL, PER_TELEPHONE) VALUES
('PER_REP_01', SHA2('Password123!',256), 'Colin', 'Raphael', 'Bayeux', '1976-11-18', 'raphael.colin@normantech.fr', '0600000061'),
('PER_REP_02', SHA2('Password123!',256), 'Hamon', 'Jade', 'Saint-Lo', '1976-01-24', 'jade.hamon@calvadosdata.fr', '0600000062'),
('PER_REP_03', SHA2('Password123!',256), 'Lopez', 'Leo', 'Cherbourg', '1990-03-08', 'leo.lopez@cotentin.fr', '0600000063');

-- 1 role par utilisateur, 3 utilisateurs par role
INSERT INTO TD_ATTRIBUE (PER_ID, ROL_ID) VALUES
('PER_SYS_01', '101'),
('PER_SYS_02', '101'),
('PER_SYS_03', '101'),
('PER_RVH_01', '201'),
('PER_RVH_02', '201'),
('PER_RVH_03', '201'),
('PER_CHD_01', '301'),
('PER_CHD_02', '301'),
('PER_CHD_03', '301'),
('PER_PAD_01', '302'),
('PER_PAD_02', '302'),
('PER_PAD_03', '302'),
('PER_DSI_01', '303'),
('PER_DSI_02', '303'),
('PER_DSI_03', '303'),
('PER_SEC_01', '304'),
('PER_SEC_02', '304'),
('PER_SEC_03', '304'),
('PER_RVC_01', '305'),
('PER_RVC_02', '305'),
('PER_RVC_03', '305'),
('PER_UCO_01', '401'),
('PER_UCO_02', '401'),
('PER_UCO_03', '401'),
('PER_DET_01', '501'),
('PER_DET_02', '501'),
('PER_DET_03', '501'),
('PER_TIT_01', '502'),
('PER_TIT_02', '502'),
('PER_TIT_03', '502'),
('PER_VAC_01', '503'),
('PER_VAC_02', '503'),
('PER_VAC_03', '503'),
('PER_RST_01', '504'),
('PER_RST_02', '504'),
('PER_RST_03', '504'),
('PER_ETU_01', '601'),
('PER_ETU_02', '601'),
('PER_ETU_03', '601'),
('PER_APP_01', '602'),
('PER_APP_02', '602'),
('PER_APP_03', '602'),
('PER_BDE_01', '603'),
('PER_BDE_02', '603'),
('PER_BDE_03', '603'),
('PER_ELU_01', '604'),
('PER_ELU_02', '604'),
('PER_ELU_03', '604'),
('PER_AMB_01', '701'),
('PER_AMB_02', '701'),
('PER_AMB_03', '701'),
('PER_CRO_01', '702'),
('PER_CRO_02', '702'),
('PER_CRO_03', '702'),
('PER_SSE_01', '703'),
('PER_SSE_02', '703'),
('PER_SSE_03', '703'),
('PER_UNC_01', '704'),
('PER_UNC_02', '704'),
('PER_UNC_03', '704'),
('PER_REP_01', '705'),
('PER_REP_02', '705'),
('PER_REP_03', '705');

-- Roles Systeme / Administratif / Administration
INSERT INTO TD_ADMINISTRATION (PER_ID, ADM_DATE_EMBAUCHE) VALUES
('PER_SYS_01', '2011-07-24'),
('PER_SYS_02', '2022-06-03'),
('PER_SYS_03', '2018-10-11'),
('PER_RVH_01', '2015-04-11'),
('PER_RVH_02', '2018-10-03'),
('PER_RVH_03', '2014-08-16'),
('PER_CHD_01', '2013-10-14'),
('PER_CHD_02', '2010-08-02'),
('PER_CHD_03', '2008-10-08'),
('PER_PAD_01', '2017-02-04'),
('PER_PAD_02', '2016-09-25'),
('PER_PAD_03', '2007-09-15'),
('PER_DSI_01', '2022-08-14'),
('PER_DSI_02', '2006-09-21'),
('PER_DSI_03', '2008-02-16'),
('PER_SEC_01', '2009-02-04'),
('PER_SEC_02', '2019-09-28'),
('PER_SEC_03', '2009-04-03'),
('PER_RVC_01', '2023-06-07'),
('PER_RVC_02', '2020-12-05'),
('PER_RVC_03', '2015-02-19');

-- Directeurs des etudes, titulaires, responsables de stage ET vacataires (FK de TD_VACATAIRE)
INSERT INTO TD_ENSEIGNANT (PER_ID, ENS_DATE_EMBAUCHE) VALUES
('PER_DET_01', '2017-01-15'),
('PER_DET_02', '2005-02-02'),
('PER_DET_03', '2012-04-18'),
('PER_TIT_01', '2012-03-23'),
('PER_TIT_02', '2017-01-11'),
('PER_TIT_03', '2014-03-01'),
('PER_RST_01', '2015-07-14'),
('PER_RST_02', '2009-04-21'),
('PER_RST_03', '2016-01-28'),
('PER_VAC_01', '2025-06-29'),
('PER_VAC_02', '2020-09-24'),
('PER_VAC_03', '2024-06-25');

INSERT INTO TD_VACATAIRE (PER_ID, VAC_STATUT_PRO, VAC_TAUX_HORAIRE) VALUES
('PER_VAC_01', 'Salarie', 45.5),
('PER_VAC_02', 'Auto-entrepreneur', 52.0),
('PER_VAC_03', 'Retraite', 41.2);

INSERT INTO TD_REPRESENTANT (PER_ID, ENT_ID) VALUES
('PER_REP_01', 'ENT_01'),
('PER_REP_02', 'ENT_02'),
('PER_REP_03', 'ENT_03');

-- Etudiants, apprentis, BDE et elus
INSERT INTO TD_ETUDIANT (PER_ID, GRP_ID) VALUES
('PER_ETU_01', 'TD11'),
('PER_ETU_02', 'TD12'),
('PER_ETU_03', 'TD21'),
('PER_APP_01', 'TD11'),
('PER_APP_02', 'TD12'),
('PER_APP_03', 'TD21'),
('PER_BDE_01', 'TD11'),
('PER_BDE_02', 'TD12'),
('PER_BDE_03', 'TD21'),
('PER_ELU_01', 'TD11'),
('PER_ELU_02', 'TD12'),
('PER_ELU_03', 'TD21');

-- Stagiaires = les 3 etudiants du role Etudiant ; PER_ID_1 = responsable de stage, PER_ID_2 = responsable entreprise
INSERT INTO TD_STAGIAIRE (PER_ID, PER_ID_1, PER_ID_2, STA_CONVENTION, STA_STATUT, STA_DATE_DEBUT, STA_DATE_FIN) VALUES
('PER_ETU_01', 'PER_RST_01', 'PER_REP_01', 'convention_stage_01.pdf', 'En cours', '2027-04-01', '2027-06-30'),
('PER_ETU_02', 'PER_RST_02', 'PER_REP_02', 'convention_stage_02.pdf', 'Valide', '2027-04-15', '2027-07-15'),
('PER_ETU_03', 'PER_RST_03', 'PER_REP_03', 'convention_stage_03.pdf', 'En attente', '2027-05-01', '2027-07-31');

-- PER_ID_1 = enseignant titulaire tuteur, PER_ID_2 = responsable entreprise
INSERT INTO TD_APPRENTI (PER_ID, PER_ID_1, PER_ID_2, APP_CONTRAT, APP_STATUT, APP_RESULTAT) VALUES
('PER_APP_01', 'PER_TIT_01', 'PER_REP_01', 'contrat_apprenti_01.pdf', 'En cours', 'Admis'),
('PER_APP_02', 'PER_TIT_02', 'PER_REP_02', 'contrat_apprenti_02.pdf', 'En cours', 'En attente'),
('PER_APP_03', 'PER_TIT_03', 'PER_REP_03', 'contrat_apprenti_03.pdf', 'Termine', 'Admis');

INSERT INTO AMBASSADEUR (PER_ID) VALUES
('PER_AMB_01'),
('PER_AMB_02'),
('PER_AMB_03');


-- -----------------------------------------------------------------------------
--  3. ECOLES SUPERIEURES, SOUHAITS, AMBASSADEURS
-- -----------------------------------------------------------------------------

INSERT INTO TD_ECOLE_SUP (ECO_ID, ECO_NOM, ECO_VILLE, ECO_ADRESSE, ECO_CODE_POSTAL, ECO_MAIL, ECO_TELEPHONE, ECO_DESCRIPTION) VALUES
('ECO_01', 'Ecole Ingenieurs Normandie', 'Caen', '10 rue de la Gare', '14000', 'admissions@ein-normandie.fr', '0231000101', 'Ecole d ingenieurs generaliste'),
('ECO_02', 'Institut Numerique Rouen', 'Rouen', '4 place du Vieux Marche', '76000', 'contact@inr-rouen.fr', '0235000102', 'Cursus numerique et alternance'),
('ECO_03', 'Universite Rennes Tech', 'Rennes', '15 boulevard de la Tour', '35000', 'info@rennes-tech.fr', '0299000103', 'Master informatique et dev'),
('ECO_04', 'Ecole Superieure Cyber Paris', 'Paris', '42 avenue des Gobelins', '75013', 'admission@esc-paris.fr', '0140000104', 'Specialisee cybersecurite'),
('ECO_05', 'Ecole Data Lille', 'Lille', '9 rue Nationale', '59000', 'contact@data-lille.fr', '0320000105', 'Data science et recherche'),
('ECO_06', 'Bordeaux Digital School', 'Bordeaux', '21 cours de l Intendance', '33000', 'hello@bdx-digital.fr', '0556000106', NULL);

INSERT INTO INCLUS (ECO_ID, KEY_ID) VALUES
('ECO_01', 'KEY_01'),
('ECO_01', 'KEY_05'),
('ECO_01', 'KEY_09'),
('ECO_02', 'KEY_01'),
('ECO_02', 'KEY_04'),
('ECO_02', 'KEY_06'),
('ECO_03', 'KEY_01'),
('ECO_03', 'KEY_10'),
('ECO_03', 'KEY_07'),
('ECO_04', 'KEY_02'),
('ECO_04', 'KEY_04'),
('ECO_04', 'KEY_07'),
('ECO_05', 'KEY_03'),
('ECO_05', 'KEY_08'),
('ECO_05', 'KEY_07'),
('ECO_06', 'KEY_01'),
('ECO_06', 'KEY_10'),
('ECO_06', 'KEY_06');

INSERT INTO AMBASSADE (ECO_ID, PER_ID) VALUES
('ECO_01', 'PER_AMB_01'),
('ECO_02', 'PER_AMB_01'),
('ECO_03', 'PER_AMB_02'),
('ECO_04', 'PER_AMB_02'),
('ECO_05', 'PER_AMB_03'),
('ECO_06', 'PER_AMB_03');

-- 2 souhaits par etudiant
INSERT INTO SOUHAIT (PER_ID, ECO_ID) VALUES
('PER_ETU_01', 'ECO_01'),
('PER_ETU_02', 'ECO_02'),
('PER_ETU_03', 'ECO_03'),
('PER_APP_01', 'ECO_04'),
('PER_APP_02', 'ECO_05'),
('PER_APP_03', 'ECO_06'),
('PER_BDE_01', 'ECO_01'),
('PER_BDE_02', 'ECO_02'),
('PER_BDE_03', 'ECO_03'),
('PER_ELU_01', 'ECO_04'),
('PER_ELU_02', 'ECO_05'),
('PER_ELU_03', 'ECO_06'),
('PER_ETU_01', 'ECO_03'),
('PER_ETU_02', 'ECO_04'),
('PER_ETU_03', 'ECO_05'),
('PER_APP_01', 'ECO_06'),
('PER_APP_02', 'ECO_01'),
('PER_APP_03', 'ECO_02'),
('PER_BDE_01', 'ECO_03'),
('PER_BDE_02', 'ECO_04'),
('PER_BDE_03', 'ECO_05'),
('PER_ELU_01', 'ECO_06'),
('PER_ELU_02', 'ECO_01'),
('PER_ELU_03', 'ECO_02');

INSERT INTO TD_FICHE_PARCOURSUP (FPS_ANNEE, FPS_FICHE2, FPS_FICHE3) VALUES
('2023', 'fiche2_2023.pdf', 'fiche3_2023.pdf'),
('2024', 'fiche2_2024.pdf', 'fiche3_2024.pdf'),
('2025', 'fiche2_2025.pdf', 'fiche3_2025.pdf'),
('2026', 'fiche2_2026.pdf', NULL);

INSERT INTO TD_QUESTION_AMBASSADEUR (QUA_ID, PER_ID, PER_ID_1, QUA_OBJET, QUA_MESSAGE, QUA_REPONSE) VALUES
('QUA_01', 'PER_ETU_01', 'PER_AMB_01', 'Admission ingenieur', 'Bonjour, quel niveau faut-il pour entrer en cycle ingenieur apres le BUT ?', 'Il faut un bon dossier et un classement dans les 30 premiers pourcentages de la promo.'),
('QUA_02', 'PER_ETU_02', 'PER_AMB_01', 'Vie etudiante', 'Comment se passe la vie associative dans ton ecole ?', 'Tres riche : une vingtaine d associations et un gros week-end d integration.'),
('QUA_03', 'PER_ETU_03', 'PER_AMB_02', 'Alternance', 'Est-il facile de trouver une entreprise pour l alternance ?', 'Le service relations entreprises envoie les offres des septembre, ca se passe bien.'),
('QUA_04', 'PER_APP_01', 'PER_AMB_02', 'Specialisation cyber', 'La specialisation cyber demande-t-elle un niveau maths eleve ?', 'Un niveau correct suffit, le plus important est le gout pour les reseaux.'),
('QUA_05', 'PER_APP_02', 'PER_AMB_03', 'Master data', 'Quels profils sont acceptes en master data ?', 'Principalement des profils info ou maths, avec un projet personnel apprecie.'),
('QUA_06', 'PER_APP_03', 'PER_AMB_03', 'Poursuite apres BUT', 'Peut-on poursuivre en alternance apres le BUT ?', 'Oui, la plupart des ecoles proposent le rythme alterne en 4e et 5e annee.'),
('QUA_07', 'PER_BDE_01', 'PER_AMB_01', 'Logement', 'Y a-t-il des residences etudiantes pres de l ecole ?', 'Oui, deux residences a moins de 10 minutes, a reserver tot.'),
('QUA_08', 'PER_BDE_02', 'PER_AMB_02', 'Dossier de candidature', 'Faut-il une lettre de motivation pour candidater ?', NULL);

INSERT INTO TD_QUESTION_DOCINFO (QDI_ID, SUJ_ID, QDI_NOM, QDI_PRENOM, QDI_MAIL, QDI_MESSAGE, QDI_STATUT, QDI_REPONSE) VALUES
('QDI_01', 'SUJ_01', 'Dubois', 'Lea', 'lea.dubois@mail.fr', 'Quelles sont les dates d ouverture des candidatures ?', 'Repondue', 'Les candidatures ouvrent mi-janvier sur la plateforme nationale.'),
('QDI_02', 'SUJ_03', 'Perrin', 'Hugo', 'hugo.perrin@mail.fr', 'Peut-on faire la formation en alternance des la premiere annee ?', 'Repondue', 'Oui, selon les places proposees par les entreprises partenaires.'),
('QDI_03', 'SUJ_02', 'Colin', 'Marie', 'marie.colin@mail.fr', 'Comment obtenir un certificat de scolarite ?', 'Repondue', 'Il est telechargeable depuis l espace numerique de travail.'),
('QDI_04', 'SUJ_04', 'Henry', 'Louis', 'louis.henry@mail.fr', 'Existe-t-il un bureau des etudiants actif ?', 'Nouvelle', NULL),
('QDI_05', 'SUJ_01', 'Morel', 'Jade', 'jade.morel@mail.fr', 'Un stage de decouverte est-il possible avant l inscription ?', 'Nouvelle', NULL),
('QDI_06', 'SUJ_05', 'Lopez', 'Tom', 'tom.lopez@mail.fr', 'Quel est le contact du service handicap ?', 'Repondue', 'Ecrire au service SSE, l adresse figure sur le site.'),
('QDI_07', 'SUJ_03', 'Gauthier', 'Anna', 'anna.gauthier@mail.fr', 'Comment trouver une entreprise d accueil ?', 'Archivee', 'Consulter la plateforme d offres de l IUT.'),
('QDI_08', 'SUJ_02', 'Chevalier', 'Noe', 'noe.chevalier@mail.fr', 'Quelles sont les regles d assiduite ?', 'Nouvelle', NULL);


-- -----------------------------------------------------------------------------
--  4. MATIERES, HEURES, EVALUATIONS, RESULTATS, JURYS
-- -----------------------------------------------------------------------------

-- PER_ID = enseignant responsable
INSERT INTO TD_MATIERE (MAT_ID, PER_ID, MAT_NOM, MAT_NB_HEURE) VALUES
('MAT_01', 'PER_TIT_01', 'Algorithmique', 60),
('MAT_02', 'PER_TIT_02', 'Bases de donnees', 45),
('MAT_03', 'PER_TIT_03', 'Reseaux', 45),
('MAT_04', 'PER_DET_01', 'Programmation Web', 60),
('MAT_05', 'PER_VAC_01', 'Cybersecurite', 30),
('MAT_06', 'PER_VAC_02', 'Anglais technique', 30),
('MAT_07', 'PER_VAC_03', 'Gestion de projet', 24),
('MAT_08', 'PER_RST_01', 'Systemes d exploitation', 45);

INSERT INTO ENSEIGNER (MAT_ID, PER_ID, ENS_NB_HEURE_PREVU, NB_HEURE_EFFECTUE) VALUES
('MAT_01', 'PER_TIT_01', 40, 22),
('MAT_01', 'PER_DET_01', 20, 10),
('MAT_02', 'PER_TIT_02', 30, 14),
('MAT_02', 'PER_DET_02', 15, 6),
('MAT_03', 'PER_TIT_03', 30, 16),
('MAT_03', 'PER_VAC_01', 15, 8),
('MAT_04', 'PER_DET_01', 40, 24),
('MAT_04', 'PER_VAC_03', 20, 10),
('MAT_05', 'PER_VAC_01', 30, 12),
('MAT_06', 'PER_VAC_02', 30, 14),
('MAT_07', 'PER_VAC_03', 24, 8),
('MAT_08', 'PER_RST_01', 25, 10),
('MAT_08', 'PER_RST_02', 20, 8);

INSERT INTO TD_HEURE (HEU_NUM, MAT_ID, HEU_STATUT, HEU_DATE_DEBUT, HEU_DATE_FIN) VALUES
(1, 'MAT_01', 'Realisee', '2026-09-07 08:00:00', '2026-09-07 10:00:00'),
(2, 'MAT_02', 'Realisee', '2026-09-11 10:15:00', '2026-09-11 12:15:00'),
(3, 'MAT_03', 'Realisee', '2026-09-15 13:30:00', '2026-09-15 15:30:00'),
(4, 'MAT_04', 'Realisee', '2026-09-21 15:45:00', '2026-09-21 17:45:00'),
(5, 'MAT_05', 'Realisee', '2026-09-23 08:00:00', '2026-09-23 10:00:00'),
(6, 'MAT_06', 'Realisee', '2026-09-28 10:15:00', '2026-09-28 12:15:00'),
(7, 'MAT_07', 'Realisee', '2026-10-01 13:30:00', '2026-10-01 15:30:00'),
(8, 'MAT_08', 'Realisee', '2026-10-05 15:45:00', '2026-10-05 17:45:00'),
(9, 'MAT_01', 'Annulee', '2026-10-09 08:00:00', '2026-10-09 10:00:00'),
(10, 'MAT_02', 'Realisee', '2026-10-13 10:15:00', '2026-10-13 12:15:00'),
(11, 'MAT_03', 'Realisee', '2026-10-19 13:30:00', '2026-10-19 15:30:00'),
(12, 'MAT_04', 'Realisee', '2026-10-21 15:45:00', '2026-10-21 17:45:00'),
(13, 'MAT_05', 'Realisee', '2026-10-26 08:00:00', '2026-10-26 10:00:00'),
(14, 'MAT_06', 'Realisee', '2026-10-29 10:15:00', '2026-10-29 12:15:00'),
(15, 'MAT_07', 'Realisee', '2026-11-02 13:30:00', '2026-11-02 15:30:00'),
(16, 'MAT_08', 'Realisee', '2026-11-06 15:45:00', '2026-11-06 17:45:00'),
(17, 'MAT_01', 'Realisee', '2026-11-10 08:00:00', '2026-11-10 10:00:00'),
(18, 'MAT_02', 'Annulee', '2026-11-16 10:15:00', '2026-11-16 12:15:00'),
(19, 'MAT_03', 'Realisee', '2026-11-18 13:30:00', '2026-11-18 15:30:00'),
(20, 'MAT_04', 'Realisee', '2026-11-23 15:45:00', '2026-11-23 17:45:00'),
(21, 'MAT_05', 'Realisee', '2026-11-26 08:00:00', '2026-11-26 10:00:00'),
(22, 'MAT_06', 'Planifiee', '2026-11-30 10:15:00', '2026-11-30 12:15:00'),
(23, 'MAT_07', 'Planifiee', '2026-12-04 13:30:00', '2026-12-04 15:30:00'),
(24, 'MAT_08', 'Planifiee', '2026-12-08 15:45:00', '2026-12-08 17:45:00');

-- EVA_01 a EVA_06 passees (avec resultats), EVA_07 a EVA_10 a venir
INSERT INTO TD_EVALUATION (EVA_ID, PRO_ID, MAT_ID, TYE_ID, EVA_DATE, EVA_SALLE) VALUES
('EVA_01', 'BUINFO1A', 'MAT_01', 'TYE_01', '2026-10-05 09:00:00', 'Amphi A'),
('EVA_02', 'BUINFO1A', 'MAT_02', 'TYE_03', '2026-10-12 10:15:00', 'Salle TP 1'),
('EVA_03', 'BUINFO1A', 'MAT_03', 'TYE_01', '2026-10-19 13:30:00', 'Salle 204'),
('EVA_04', 'BUINFO1A', 'MAT_04', 'TYE_04', '2026-10-26 08:00:00', 'Salle TP 2'),
('EVA_05', 'BUINFO1A', 'MAT_01', 'TYE_02', '2026-11-09 09:00:00', 'Amphi B'),
('EVA_06', 'BUINFO1A', 'MAT_06', 'TYE_05', '2026-11-16 14:00:00', 'Salle 110'),
('EVA_07', 'BUINFO1A', 'MAT_05', 'TYE_01', '2026-12-07 10:00:00', 'Salle 204'),
('EVA_08', 'BUINFO1A', 'MAT_07', 'TYE_04', '2026-12-14 13:30:00', 'Salle 110'),
('EVA_09', 'BUINFO1A', 'MAT_02', 'TYE_02', '2027-01-11 09:00:00', 'Amphi A'),
('EVA_10', 'BUINFO1A', 'MAT_08', 'TYE_03', '2027-01-18 10:15:00', 'Salle TP 1');

-- Notes sur 20, 'ABS' = absent
INSERT INTO TD_RESULTAT (PER_ID, EVA_ID, RES_NOTE) VALUES
('PER_ETU_01', 'EVA_01', '15.50'),
('PER_ETU_02', 'EVA_01', '15.00'),
('PER_ETU_03', 'EVA_01', '13.50'),
('PER_APP_01', 'EVA_01', '10.00'),
('PER_APP_02', 'EVA_01', '14.50'),
('PER_APP_03', 'EVA_01', '8.50'),
('PER_BDE_01', 'EVA_01', '12.00'),
('PER_BDE_02', 'EVA_01', '12.50'),
('PER_BDE_03', 'EVA_01', '18.50'),
('PER_ELU_01', 'EVA_01', '17.50'),
('PER_ELU_02', 'EVA_01', '10.00'),
('PER_ELU_03', 'EVA_01', '13.00'),
('PER_ETU_01', 'EVA_02', '9.00'),
('PER_ETU_02', 'EVA_02', '18.00'),
('PER_ETU_03', 'EVA_02', '17.50'),
('PER_APP_01', 'EVA_02', '10.50'),
('PER_APP_02', 'EVA_02', '14.50'),
('PER_APP_03', 'EVA_02', '14.50'),
('PER_BDE_01', 'EVA_02', '9.00'),
('PER_BDE_02', 'EVA_02', '16.00'),
('PER_BDE_03', 'EVA_02', '13.50'),
('PER_ELU_01', 'EVA_02', '16.50'),
('PER_ELU_02', 'EVA_02', '13.50'),
('PER_ELU_03', 'EVA_02', '7.00'),
('PER_ETU_01', 'EVA_03', '11.00'),
('PER_ETU_02', 'EVA_03', '7.00'),
('PER_ETU_03', 'EVA_03', 'ABS'),
('PER_APP_01', 'EVA_03', '18.00'),
('PER_APP_02', 'EVA_03', '17.50'),
('PER_APP_03', 'EVA_03', '17.00'),
('PER_BDE_01', 'EVA_03', '10.50'),
('PER_BDE_02', 'EVA_03', '7.50'),
('PER_BDE_03', 'EVA_03', '17.50'),
('PER_ELU_01', 'EVA_03', '18.50'),
('PER_ELU_02', 'EVA_03', '8.00'),
('PER_ELU_03', 'EVA_03', '13.00'),
('PER_ETU_01', 'EVA_04', '8.00'),
('PER_ETU_02', 'EVA_04', '16.00'),
('PER_ETU_03', 'EVA_04', '16.00'),
('PER_APP_01', 'EVA_04', '8.50'),
('PER_APP_02', 'EVA_04', '12.50'),
('PER_APP_03', 'EVA_04', '13.50'),
('PER_BDE_01', 'EVA_04', '10.00'),
('PER_BDE_02', 'EVA_04', '17.50'),
('PER_BDE_03', 'EVA_04', '12.00'),
('PER_ELU_01', 'EVA_04', '9.50'),
('PER_ELU_02', 'EVA_04', '13.50'),
('PER_ELU_03', 'EVA_04', '16.00'),
('PER_ETU_01', 'EVA_05', '9.50'),
('PER_ETU_02', 'EVA_05', '10.50'),
('PER_ETU_03', 'EVA_05', '19.00'),
('PER_APP_01', 'EVA_05', '15.00'),
('PER_APP_02', 'EVA_05', '12.50'),
('PER_APP_03', 'EVA_05', '13.00'),
('PER_BDE_01', 'EVA_05', '8.50'),
('PER_BDE_02', 'EVA_05', '9.50'),
('PER_BDE_03', 'EVA_05', '11.00'),
('PER_ELU_01', 'EVA_05', '14.00'),
('PER_ELU_02', 'EVA_05', '10.00'),
('PER_ELU_03', 'EVA_05', '9.50'),
('PER_ETU_01', 'EVA_06', '8.00'),
('PER_ETU_02', 'EVA_06', '14.50'),
('PER_ETU_03', 'EVA_06', '9.50'),
('PER_APP_01', 'EVA_06', '18.00'),
('PER_APP_02', 'EVA_06', '17.50'),
('PER_APP_03', 'EVA_06', '8.00'),
('PER_BDE_01', 'EVA_06', '10.00'),
('PER_BDE_02', 'EVA_06', '15.00'),
('PER_BDE_03', 'EVA_06', '9.50'),
('PER_ELU_01', 'EVA_06', '8.50'),
('PER_ELU_02', 'EVA_06', '18.00'),
('PER_ELU_03', 'EVA_06', '14.00');

-- 2 enseignants par evaluation
INSERT INTO TD_JURY (PER_ID, EVA_ID) VALUES
('PER_TIT_01', 'EVA_01'),
('PER_DET_01', 'EVA_01'),
('PER_TIT_02', 'EVA_02'),
('PER_DET_02', 'EVA_02'),
('PER_TIT_03', 'EVA_03'),
('PER_DET_03', 'EVA_03'),
('PER_DET_01', 'EVA_04'),
('PER_TIT_01', 'EVA_04'),
('PER_TIT_01', 'EVA_05'),
('PER_TIT_02', 'EVA_05'),
('PER_VAC_02', 'EVA_06'),
('PER_TIT_03', 'EVA_06'),
('PER_VAC_01', 'EVA_07'),
('PER_VAC_02', 'EVA_07'),
('PER_VAC_03', 'EVA_08'),
('PER_VAC_02', 'EVA_08'),
('PER_TIT_02', 'EVA_09'),
('PER_VAC_03', 'EVA_09'),
('PER_RST_01', 'EVA_10'),
('PER_RST_02', 'EVA_10');


-- -----------------------------------------------------------------------------
--  5. ABSENCES, AMENAGEMENTS, SANCTIONS, BDE, EVENEMENTS
-- -----------------------------------------------------------------------------

INSERT INTO TD_ABSENCE (ABS_ID, PER_ID, ABS_DATE_DEBUT, ABS_DATE_FIN, ABS_JUSTIFICATIF, ABS_STATUT) VALUES
('ABS_01', 'PER_ETU_01', '2026-09-15 08:00:00', '2026-09-15 12:15:00', 'certificat_medical_01.pdf', 'Justifiee'),
('ABS_02', 'PER_ETU_03', '2026-10-19 13:30:00', '2026-10-19 15:30:00', NULL, 'Non justifiee'),
('ABS_03', 'PER_ETU_02', '2026-10-02 08:00:00', '2026-10-02 17:45:00', 'convocation_permis.pdf', 'Justifiee'),
('ABS_04', 'PER_APP_02', '2026-10-08 08:00:00', '2026-10-09 17:45:00', NULL, 'En attente'),
('ABS_05', 'PER_BDE_02', '2026-11-03 10:15:00', '2026-11-03 12:15:00', NULL, 'Non justifiee'),
('ABS_06', 'PER_APP_03', '2026-11-05 08:00:00', '2026-11-05 10:00:00', 'certificat_medical_02.pdf', 'Justifiee'),
('ABS_07', 'PER_APP_01', '2026-11-10 13:30:00', '2026-11-10 17:45:00', 'attestation_entreprise.pdf', 'Justifiee'),
('ABS_08', 'PER_ELU_02', '2026-11-12 08:00:00', '2026-11-12 12:15:00', NULL, 'En attente'),
('ABS_09', 'PER_BDE_03', '2026-11-17 08:00:00', '2026-11-17 10:00:00', NULL, 'Non justifiee'),
('ABS_10', 'PER_ETU_01', '2026-11-24 13:30:00', '2026-11-24 15:30:00', 'certificat_medical_03.pdf', 'En attente');

INSERT INTO TD_AMENAGEMENT (AME_ID, PER_ID, AME_LIBELLE, AME_STATUT) VALUES
('AME_01', 'PER_ETU_02', 'Tiers temps', 'Valide'),
('AME_02', 'PER_ETU_01', 'Ordinateur en examen', 'Valide'),
('AME_03', 'PER_APP_02', 'Salle isolee', 'En attente'),
('AME_04', 'PER_ELU_01', 'Preneur de notes', 'Refuse');

-- PER_ID = chef de departement / secretaire qui prononce la sanction
INSERT INTO TD_SANCTION (SAN_ID, PER_ID, GRA_ID, SAN_DATE, SAN_STATUT) VALUES
('SAN_01', 'PER_CHD_01', 'GRA_1', '2026-09-25 10:00:00', 'Appliquee'),
('SAN_02', 'PER_CHD_02', 'GRA_2', '2026-10-14 14:30:00', 'Appliquee'),
('SAN_03', 'PER_CHD_01', 'GRA_2', '2026-10-30 09:00:00', 'Contestee'),
('SAN_04', 'PER_SEC_01', 'GRA_3', '2026-11-06 16:00:00', 'En cours'),
('SAN_05', 'PER_CHD_02', 'GRA_1', '2026-11-13 11:15:00', 'Annulee'),
('SAN_06', 'PER_CHD_03', 'GRA_4', '2026-11-20 15:00:00', 'En cours');

INSERT INTO CONCERNER2 (SAN_ID, PER_ID) VALUES
('SAN_01', 'PER_ETU_03'),
('SAN_02', 'PER_BDE_03'),
('SAN_03', 'PER_ETU_02'),
('SAN_03', 'PER_ELU_02'),
('SAN_04', 'PER_APP_03'),
('SAN_05', 'PER_APP_01'),
('SAN_06', 'PER_ELU_03');

-- Publie par les etudiants du role Etudiant BDE
INSERT INTO TD_INFO_BDE (BDE_ID, TYB_ID, PER_ID, BDE_TITRE, BDE_DESCRIPTION) VALUES
('BDE_01', 'TYB_01', 'PER_BDE_01', 'Week-end d integration', 'Weekend en Normandie en octobre'),
('BDE_02', 'TYB_04', 'PER_BDE_02', 'Soiree de Noel', 'Soiree le 18 decembre'),
('BDE_03', 'TYB_02', 'PER_BDE_03', 'Vente de pulls', 'Pull promo, commande ouverte'),
('BDE_04', 'TYB_03', 'PER_BDE_01', 'Partenariat cinema', 'Tarif etudiant dans un cinema'),
('BDE_05', 'TYB_01', 'PER_BDE_02', 'Tournoi de foot', 'Tournoi inter-promo en mars'),
('BDE_06', 'TYB_02', 'PER_BDE_03', 'Recherche de benevoles', 'Journee portes ouvertes'),
('BDE_07', 'TYB_04', 'PER_BDE_01', 'Soiree jeux de societe', 'Chaque jeudi soir au foyer'),
('BDE_08', 'TYB_03', 'PER_BDE_02', 'Partenariat salle de sport', 'Abonnement a prix reduit');

INSERT INTO TD_EVENEMENT (ID, PER_ID, NOM, DESCRIPTION, VILLE, ADRESSE, CODE_POSTAL, DATE) VALUES
('EVT_01', 'PER_PAD_01', 'Journee portes ouvertes', 'Presentation des formations', 'Caen', 'Campus 2, bd Marechal Juin', '14000', '2027-02-06 09:00:00'),
('EVT_02', 'PER_CHD_01', 'Forum des entreprises', 'Rencontre etudiants-entreprises', 'Caen', 'Hall de l IUT', '14000', '2026-12-10 10:00:00'),
('EVT_03', 'PER_DET_01', 'Conference cybersecurite', 'Intervention d un expert', 'Caen', 'Amphi A', '14000', '2026-12-03 14:00:00'),
('EVT_04', 'PER_PAD_02', 'Remise des diplomes', 'Ceremonie de fin d annee', 'Caen', 'Grand amphi', '14000', '2027-06-25 17:00:00'),
('EVT_05', 'PER_TIT_02', 'Hackathon 24h', 'Concours de developpement', 'Caen', 'Salles TP', '14000', '2027-03-20 09:00:00'),
('EVT_06', 'PER_AMB_01', 'Salon de l etudiant', 'Stand des ambassadeurs', 'Rouen', 'Parc des expositions', '76000', '2027-01-23 09:30:00');

-- PER_ID = personnel SSE, PER_ID_1 = etudiant
INSERT INTO TD_RDV_SSE (RDV_ID, PER_ID, PER_ID_1, RDV_DATE_DEBUT, RDV_DATE_FIN, RDV_STATUT) VALUES
('RDV_01', 'PER_SSE_01', 'PER_ETU_02', '2026-09-22 10:00:00', '2026-09-22 10:30:00', 'Realise'),
('RDV_02', 'PER_SSE_01', 'PER_ETU_01', '2026-10-06 14:00:00', '2026-10-06 14:30:00', 'Realise'),
('RDV_03', 'PER_SSE_02', 'PER_APP_02', '2026-11-04 09:00:00', '2026-11-04 09:45:00', 'Realise'),
('RDV_04', 'PER_SSE_02', 'PER_ETU_03', '2026-11-18 11:00:00', '2026-11-18 11:30:00', 'Annule'),
('RDV_05', 'PER_SSE_03', 'PER_BDE_01', '2026-12-02 15:00:00', '2026-12-02 15:30:00', 'Confirme'),
('RDV_06', 'PER_SSE_03', 'PER_APP_01', '2026-12-04 10:30:00', '2026-12-04 11:00:00', 'En attente'),
('RDV_07', 'PER_SSE_01', 'PER_ELU_01', '2026-12-09 16:00:00', '2026-12-09 16:30:00', 'En attente');

INSERT INTO TD_CROUS_FERMETURE (CRO_DATE, CRO_STATUT, CRO_RAISON) VALUES
('2026-12-24 00:00:00', 'Ferme', 'Fermeture annuelle de fin d annee'),
('2026-12-25 00:00:00', 'Ferme', 'Jour de Noel'),
('2027-01-01 00:00:00', 'Ferme', 'Jour de l An'),
('2027-04-05 00:00:00', 'Ferme', 'Lundi de Paques'),
('2026-11-30 00:00:00', 'Partiel', 'Greve du personnel');


-- -----------------------------------------------------------------------------
--  6. REUNIONS, COMPTES RENDUS, DECISIONS
-- -----------------------------------------------------------------------------

INSERT INTO TD_REUNION (REU_ID, REU_NOM, REU_DATE, REU_STATUT, REU_LIEU) VALUES
('REU_01', 'Rentree pedagogique', '2026-09-02 09:00:00', 'Terminee', 'Amphi A'),
('REU_02', 'Conseil de departement', '2026-10-15 14:00:00', 'Terminee', 'Salle de reunion 1'),
('REU_03', 'Jury semestre 1', '2026-11-20 09:30:00', 'Terminee', 'Salle de reunion 2'),
('REU_04', 'Point apprentissage', '2026-12-03 10:00:00', 'Planifiee', 'Salle 204'),
('REU_05', 'Preparation forum entreprises', '2026-12-08 14:00:00', 'Planifiee', 'Visio'),
('REU_06', 'Conseil de classe S1', '2027-01-28 13:30:00', 'Planifiee', 'Salle de reunion 1');

-- Les etudiants elus participent aux conseils de classe
INSERT INTO PARTICIPE (REU_ID, PER_ID) VALUES
('REU_01', 'PER_CHD_01'),
('REU_01', 'PER_CHD_02'),
('REU_01', 'PER_CHD_03'),
('REU_01', 'PER_SEC_01'),
('REU_01', 'PER_SEC_02'),
('REU_01', 'PER_SEC_03'),
('REU_01', 'PER_DET_01'),
('REU_01', 'PER_DET_02'),
('REU_01', 'PER_DET_03'),
('REU_01', 'PER_TIT_01'),
('REU_01', 'PER_TIT_02'),
('REU_01', 'PER_TIT_03'),
('REU_01', 'PER_VAC_01'),
('REU_01', 'PER_VAC_02'),
('REU_01', 'PER_VAC_03'),
('REU_02', 'PER_CHD_01'),
('REU_02', 'PER_CHD_02'),
('REU_02', 'PER_CHD_03'),
('REU_02', 'PER_SEC_01'),
('REU_02', 'PER_DET_01'),
('REU_02', 'PER_DET_02'),
('REU_02', 'PER_DET_03'),
('REU_02', 'PER_TIT_01'),
('REU_02', 'PER_TIT_02'),
('REU_03', 'PER_CHD_01'),
('REU_03', 'PER_DET_01'),
('REU_03', 'PER_DET_02'),
('REU_03', 'PER_DET_03'),
('REU_03', 'PER_TIT_01'),
('REU_03', 'PER_TIT_02'),
('REU_03', 'PER_TIT_03'),
('REU_03', 'PER_RST_01'),
('REU_04', 'PER_CHD_01'),
('REU_04', 'PER_DET_01'),
('REU_04', 'PER_TIT_01'),
('REU_04', 'PER_TIT_02'),
('REU_04', 'PER_REP_01'),
('REU_04', 'PER_REP_02'),
('REU_04', 'PER_APP_01'),
('REU_05', 'PER_PAD_01'),
('REU_05', 'PER_PAD_02'),
('REU_05', 'PER_SEC_01'),
('REU_05', 'PER_REP_01'),
('REU_05', 'PER_REP_03'),
('REU_05', 'PER_RST_01'),
('REU_06', 'PER_CHD_01'),
('REU_06', 'PER_DET_01'),
('REU_06', 'PER_TIT_01'),
('REU_06', 'PER_RST_01'),
('REU_06', 'PER_ELU_01'),
('REU_06', 'PER_ELU_02');

INSERT INTO TD_COMPTE_RENDU (COM_ID, TYC_ID, PER_ID, COM_ORDRE, COM_DATE, COM_DESCRIPTION, COM_DOCUMENT, COM_PUBLIC, COM_ARCHIVE) VALUES
('COM_01', 'TYC_01', 'PER_SEC_01', '1', '2026-09-02 11:00:00', 'Compte rendu de la rentree pedagogique', 'cr_rentree_2026.pdf', 1, 0),
('COM_02', 'TYC_04', 'PER_SEC_02', '2', '2026-09-18 10:00:00', 'Organisation des emplois du temps', 'cr_edt_2026.pdf', 0, 0),
('COM_03', 'TYC_01', 'PER_DET_01', '3', '2026-10-15 16:00:00', 'Bilan des premieres semaines', 'cr_conseil_dept_oct.pdf', 1, 0),
('COM_04', 'TYC_02', 'PER_TIT_02', '4', '2026-10-22 17:00:00', 'Suivi des etudiants en difficulte', 'cr_suivi_etudiants.pdf', 0, 0),
('COM_05', 'TYC_03', 'PER_RST_01', '5', '2026-11-20 12:00:00', 'Deliberations du jury S1', 'cr_jury_s1.pdf', 0, 0),
('COM_06', 'TYC_04', 'PER_PAD_01', '6', '2026-11-23 09:30:00', 'Preparation du forum entreprises', 'cr_forum_2026.pdf', 1, 0),
('COM_07', 'TYC_01', 'PER_DET_01', '7', '2025-06-10 15:00:00', 'Bilan de l annee precedente', 'cr_bilan_2025.pdf', 1, 1),
('COM_08', 'TYC_02', 'PER_TIT_02', '8', '2025-02-04 16:30:00', 'Conseil de classe S1 2024-2025', 'cr_conseil_s1_2025.pdf', 0, 1);

INSERT INTO TD_JOURNAL_COMPTE_RENDU (JCR_DATE_MODIF, COM_ID, JCR_ORDRE, JCR_DATE, JCR_DESCRIPTION, JCR_DOCUMENT, JCR_PUBLIC, JCR_ARCHIVE, JCR_TYPE, JCR_AUTEUR) VALUES
('2026-09-02 11:30:00', 'COM_01', '1', '2026-09-02 11:00:00', 'Creation du compte rendu', 'cr_rentree_2026.pdf', 1, 0, 'Creation', 'PER_SEC_01'),
('2026-09-03 08:45:00', 'COM_01', '1', '2026-09-02 11:00:00', 'Correction des noms propres', 'cr_rentree_2026_v2.pdf', 1, 0, 'Modification', 'PER_SEC_01'),
('2026-09-18 10:20:00', 'COM_02', '2', '2026-09-18 10:00:00', 'Creation du compte rendu', 'cr_edt_2026.pdf', 0, 0, 'Creation', 'PER_SEC_02'),
('2026-10-15 16:30:00', 'COM_03', '3', '2026-10-15 16:00:00', 'Creation du compte rendu', 'cr_conseil_dept_oct.pdf', 1, 0, 'Creation', 'PER_DET_01'),
('2026-10-22 17:30:00', 'COM_04', '4', '2026-10-22 17:00:00', 'Creation du compte rendu', 'cr_suivi_etudiants.pdf', 0, 0, 'Creation', 'PER_TIT_02'),
('2026-11-20 12:30:00', 'COM_05', '5', '2026-11-20 12:00:00', 'Creation du compte rendu', 'cr_jury_s1.pdf', 0, 0, 'Creation', 'PER_RST_01'),
('2026-11-23 10:00:00', 'COM_06', '6', '2026-11-23 09:30:00', 'Creation du compte rendu', 'cr_forum_2026.pdf', 0, 0, 'Creation', 'PER_PAD_01'),
('2026-11-24 09:00:00', 'COM_06', '6', '2026-11-23 09:30:00', 'Passage en public', 'cr_forum_2026.pdf', 1, 0, 'Publication', 'PER_CHD_01'),
('2025-06-11 08:00:00', 'COM_07', '7', '2025-06-10 15:00:00', 'Archivage du compte rendu', 'cr_bilan_2025.pdf', 1, 1, 'Archivage', 'PER_CHD_01');

INSERT INTO TD_DECISION (DEC_ID, COM_ID, TYD_ID, PER_ID, DEC_NOM, DEC_DATE, DEC_DESCRIPTION, DEC_DOCUMENT, DEC_PUBLIC, DEC_ARCHIVE) VALUES
('DEC_01', 'COM_01', 'TYD_01', 'PER_CHD_01', 'Validation emploi du temps', '2026-09-02 11:15:00', 'Emploi du temps S1 valide pour toutes les promos.', 'decision_edt_s1.pdf', 1, 0),
('DEC_02', 'COM_03', 'TYD_05', 'PER_DET_01', 'Amenagement tiers temps', '2026-10-15 16:20:00', 'Tiers temps accorde pour les examens.', 'decision_amenagement_01.pdf', 0, 0),
('DEC_03', 'COM_04', 'TYD_02', 'PER_TIT_02', 'Avertissement assiduite', '2026-10-22 17:20:00', 'Avertissement pour absences repetees.', 'decision_avertissement_01.pdf', 0, 0),
('DEC_04', 'COM_05', 'TYD_01', 'PER_DET_01', 'Validation du semestre 1', '2026-11-20 12:15:00', 'Validation du S1 pour 11 etudiants sur 12.', 'decision_validation_s1.pdf', 1, 0),
('DEC_05', 'COM_05', 'TYD_03', 'PER_DET_01', 'Redoublement possible', '2026-11-20 12:20:00', 'Un etudiant passe en commission de rattrapage.', 'decision_rattrapage.pdf', 0, 0),
('DEC_06', 'COM_06', 'TYD_04', 'PER_CHD_01', 'Admission apprentis', '2026-11-23 09:45:00', 'Admission de nouveaux contrats d apprentissage.', 'decision_admission_app.pdf', 1, 0),
('DEC_07', 'COM_07', 'TYD_01', 'PER_CHD_01', 'Validation bilan 2025', '2025-06-10 15:30:00', 'Bilan 2024-2025 valide.', 'decision_bilan_2025.pdf', 1, 1),
('DEC_08', 'COM_08', 'TYD_03', 'PER_TIT_02', 'Redoublement 2025', '2025-02-04 16:45:00', 'Decision de redoublement apres conseil.', 'decision_redoublement_2025.pdf', 0, 1);

INSERT INTO TD_JOURNAL_DECISION (JDE_DATE_MODIF, DEC_ID, JDE_NOM, JDE_DATE, JDE_DESCRIPTION, JDE_DOCUMENT, JDE_PUBLIC, JDE_ARCHIVE, JDE_TYPE, JDE_AUTEUR) VALUES
('2026-09-02 11:20:00', 'DEC_01', 'Validation emploi du temps', '2026-09-02 11:15:00', 'Creation de la decision', 'decision_edt_s1.pdf', 1, 0, 'Creation', 'PER_CHD_01'),
('2026-10-15 16:25:00', 'DEC_02', 'Amenagement tiers temps', '2026-10-15 16:20:00', 'Creation de la decision', 'decision_amenagement_01.pdf', 0, 0, 'Creation', 'PER_DET_01'),
('2026-10-22 17:25:00', 'DEC_03', 'Avertissement assiduite', '2026-10-22 17:20:00', 'Creation de la decision', 'decision_avertissement_01.pdf', 0, 0, 'Creation', 'PER_TIT_02'),
('2026-10-23 09:00:00', 'DEC_03', 'Avertissement assiduite', '2026-10-22 17:20:00', 'Precision sur la periode', 'decision_avertissement_01.pdf', 0, 0, 'Modification', 'PER_TIT_02'),
('2026-11-20 12:30:00', 'DEC_04', 'Validation du semestre 1', '2026-11-20 12:15:00', 'Creation de la decision', 'decision_validation_s1.pdf', 0, 0, 'Creation', 'PER_DET_01'),
('2026-11-21 08:30:00', 'DEC_04', 'Validation du semestre 1', '2026-11-20 12:15:00', 'Passage en public', 'decision_validation_s1.pdf', 1, 0, 'Publication', 'PER_CHD_01'),
('2026-11-23 09:50:00', 'DEC_06', 'Admission apprentis', '2026-11-23 09:45:00', 'Creation de la decision', 'decision_admission_app.pdf', 1, 0, 'Creation', 'PER_CHD_01'),
('2025-06-10 16:00:00', 'DEC_07', 'Validation bilan 2025', '2025-06-10 15:30:00', 'Archivage de la decision', 'decision_bilan_2025.pdf', 1, 1, 'Archivage', 'PER_CHD_01');

INSERT INTO INCLURE (DEC_ID, KEY_ID) VALUES
('DEC_01', 'KEY_01'),
('DEC_02', 'KEY_01'),
('DEC_03', 'KEY_01'),
('DEC_04', 'KEY_01'),
('DEC_04', 'KEY_07'),
('DEC_05', 'KEY_01'),
('DEC_06', 'KEY_06'),
('DEC_06', 'KEY_10'),
('DEC_07', 'KEY_05'),
('DEC_08', 'KEY_01');


-- -----------------------------------------------------------------------------
--  7. DOSSIERS, CHECKLISTS, PAIEMENTS VACATAIRES
-- -----------------------------------------------------------------------------

INSERT INTO TD_DOSSIER_VACATAIRE (DOV_ID, PER_ID, DOV_STATUT, DOV_CARTEID, DOV_CV) VALUES
('DOV_01', 'PER_VAC_01', 'Complet', 'cni_vacataire_01.pdf', 'cv_vacataire_01.pdf'),
('DOV_02', 'PER_VAC_02', 'En validation', 'cni_vacataire_02.pdf', 'cv_vacataire_02.pdf'),
('DOV_03', 'PER_VAC_03', 'Incomplet', 'cni_vacataire_03.pdf', 'cv_vacataire_03.pdf');

-- PK = PER_ID seul : une seule ligne par vacataire possible
INSERT INTO TD_CHECKLIST (ETA_ID, PER_ID, CHE_LIBELLE, CHE_DESCRIPTION, CHE_STATUT) VALUES
('ETA_04', 'PER_VAC_01', 'Contrat signe', 'Contrat retourne le 02/09', 'Valide'),
('ETA_03', 'PER_VAC_02', 'RIB', 'RIB en cours de verification', 'En cours'),
('ETA_05', 'PER_VAC_03', 'Attestation employeur', 'Document manquant', 'Manquant');

-- PK = PAI_MOIS seul : un seul paiement par mois pour l ensemble des vacataires
INSERT INTO TD_PAIEMENT_VACATAIRE (PAI_MOIS, PER_ID, PAI_DATE_PAIEMENT, PAI_STATUT, PAI_MONTANT) VALUES
('2026-04-01', 'PER_VAC_01', '2026-04-28', 'Paye', 1365),
('2026-05-01', 'PER_VAC_02', '2026-05-28', 'Paye', 1560),
('2026-06-01', 'PER_VAC_03', '2026-06-28', 'Paye', 824),
('2026-07-01', 'PER_VAC_01', '2026-07-28', 'Paye', 910),
('2026-09-01', 'PER_VAC_02', '2026-09-28', 'Paye', 780),
('2026-10-01', 'PER_VAC_03', '2026-10-28', 'Paye', 988),
('2026-11-01', 'PER_VAC_01', NULL, 'En attente', 1137),
('2026-12-01', 'PER_VAC_02', NULL, 'Prevu', 1040);


-- -----------------------------------------------------------------------------
--  8. TEMPLATES DE MAIL, PIECES JOINTES
-- -----------------------------------------------------------------------------

INSERT INTO TD_PIECE_JOINTE (PJ_ID, PJ_NOM_FICHIER, PJ_CHEMIN, PJ_MIME_TYPE, PJ_TAILLE_OCTET, PJ_DATE_DEPOT) VALUES
(1, 'livret_accueil.pdf', '/uploads/templates/livret_accueil.pdf', 'application/pdf', 1843200, '2026-08-25 10:00:00'),
(2, 'plan_campus.png', '/uploads/templates/plan_campus.png', 'image/png', 524288, '2026-08-25 10:05:00'),
(3, 'reglement_interieur.pdf', '/uploads/templates/reglement_interieur.pdf', 'application/pdf', 734003, '2026-08-26 09:30:00'),
(4, 'modele_convention.docx', '/uploads/templates/modele_convention.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 98304, '2026-09-01 14:00:00'),
(5, 'calendrier_examens.pdf', '/uploads/templates/calendrier_examens.pdf', 'application/pdf', 262144, '2026-10-01 08:45:00'),
(6, 'guide_vacataire.pdf', '/uploads/templates/guide_vacataire.pdf', 'application/pdf', 1048576, '2026-09-02 16:20:00');

INSERT INTO TD_TEMPLATE_MAIL (TEM_NUM, TEM_OBJET, TEM_CORPS) VALUES
(1, 'Bienvenue a l IUT', 'Bonjour {{prenom}},

Bienvenue ! Vous trouverez en piece jointe le livret d accueil et le plan du campus.

Cordialement,
Le secretariat'),
(2, 'Convocation jury', 'Bonjour {{prenom}},

Vous etes convoque(e) au jury d evaluation du {{date}} en salle {{salle}}.

Cordialement,
Le secretariat'),
(3, 'Dossier vacataire incomplet', 'Bonjour {{prenom}},

Votre dossier de vacataire est incomplet. Merci de nous transmettre les pieces manquantes.

Cordialement,
Le secretariat'),
(4, 'Convention de stage', 'Bonjour {{prenom}},

Veuillez trouver le modele de convention de stage a faire signer par l entreprise.

Cordialement,
Le secretariat'),
(5, 'Rappel calendrier examens', 'Bonjour {{prenom}},

Le calendrier des examens du semestre est disponible en piece jointe.

Cordialement,
Le secretariat'),
(6, 'Information absence', 'Bonjour {{prenom}},

Votre absence du {{date}} n a pas ete justifiee. Merci de deposer un justificatif sous 48h.

Cordialement,
Le secretariat');

INSERT INTO TD_JOINDRE (TEM_NUM, PJ_ID) VALUES
(1, 1),
(1, 2),
(2, 5),
(3, 6),
(4, 4),
(5, 5),
(6, 3);

INSERT INTO TD_DESTINER (TEM_NUM, PER_ID) VALUES
(1, 'PER_ETU_01'),
(1, 'PER_ETU_02'),
(1, 'PER_ETU_03'),
(1, 'PER_APP_01'),
(1, 'PER_APP_02'),
(1, 'PER_APP_03'),
(1, 'PER_BDE_01'),
(1, 'PER_BDE_02'),
(1, 'PER_BDE_03'),
(1, 'PER_ELU_01'),
(1, 'PER_ELU_02'),
(1, 'PER_ELU_03'),
(2, 'PER_DET_01'),
(2, 'PER_DET_02'),
(2, 'PER_DET_03'),
(2, 'PER_TIT_01'),
(2, 'PER_TIT_02'),
(2, 'PER_TIT_03'),
(2, 'PER_VAC_01'),
(2, 'PER_VAC_02'),
(2, 'PER_VAC_03'),
(2, 'PER_RST_01'),
(2, 'PER_RST_02'),
(2, 'PER_RST_03'),
(3, 'PER_VAC_01'),
(3, 'PER_VAC_02'),
(3, 'PER_VAC_03'),
(4, 'PER_ETU_01'),
(4, 'PER_ETU_02'),
(4, 'PER_ETU_03'),
(4, 'PER_REP_01'),
(4, 'PER_REP_02'),
(4, 'PER_REP_03'),
(4, 'PER_RST_01'),
(4, 'PER_RST_02'),
(4, 'PER_RST_03'),
(5, 'PER_ETU_01'),
(5, 'PER_ETU_02'),
(5, 'PER_ETU_03'),
(5, 'PER_APP_01'),
(5, 'PER_APP_02'),
(5, 'PER_APP_03'),
(5, 'PER_BDE_01'),
(5, 'PER_BDE_02'),
(5, 'PER_BDE_03'),
(5, 'PER_ELU_01'),
(5, 'PER_ELU_02'),
(5, 'PER_ELU_03'),
(6, 'PER_ETU_03'),
(6, 'PER_BDE_03'),
(6, 'PER_ETU_02');


