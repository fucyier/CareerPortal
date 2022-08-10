// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract BaseContract{
     address YOK;
  address TOBB;
  address CB;
  struct  Kisi
    {
      bool durum;
    
    }
   struct Universite
        {
        bool durum;
        string isim;
        uint8 ulke;
        }

        struct Akademisyen
        {
        bool durum;
        address universite;
        uint16 bolum;
        Unvan unvan; 
        string ad;
        string soyad;
        }

        enum Unvan { DR, AS_PROF, PROF,MD }    
         enum Seviye { Temel, Orta, Iyi, Ileri }    
  enum OnaylayanKurum { 
             Universite, 
             Firma, 
             Kamu,
             STK,
             SertifikaMerkezi,
             Kurs 
             }
     struct Firma
    {
      bool durum;
      uint8 ulke;
      uint vergiNo;
      string isim;
    }
     struct KamuKurumu
    {
      bool durum;
      string isim;
      uint8 ulke;
    }
      struct STK
    {
      bool durum;
      string isim;
      uint8 ulke;
    }
      struct SertifikaMerkezi
    {
      bool durum;
      string isim;
      uint8 ulke;
    }
    struct Kurs
    {
      bool durum;
      string isim;
      uint8 ulke;
    }

     struct YabanciDil
    {
      uint32 id;
      string isim;
    }
      modifier sadeceYOK{
      require(msg.sender == YOK,
      "Sadece YOK bu islemi yapabilir."
      );
      _;
     }    
    
      modifier sadeceTOBB{
      require(msg.sender == TOBB,
      "Sadece TOBB bu islemi yapabilir."
      );
      _;
     }

      modifier sadeceCB{
      require(msg.sender == CB,
      "Sadece CB bu islemi yapabilir."
      );
      _;
    }    

      modifier sadeceUniversite{
      require(universiteler[msg.sender].durum,
      "Sadece Universite bu islemi yapabilir."
      );
      _;
    } 

      modifier sadeceKurs{
      require(kurslar[msg.sender].durum,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
        modifier onlyCourse{
      require(sertifikaMerkezleri[msg.sender].durum,
      "Bu islemi sadece Sertifika Merkezleri yapabilir."
      );
      _;
    } 

      modifier sadece_Uni_Firma_Kamu{
      require(universiteler[msg.sender].durum||firmalar[msg.sender].durum||kamuKurumlari[msg.sender].durum,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
      modifier onlyKontratSahibi {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir"
      );
      _;
    }

    mapping(address=>Kisi) public kisiler;
    mapping(address=>Universite) public universiteler;
    mapping(address=>Akademisyen) public akademisyenler;
    mapping(address=>Firma) public  firmalar;
    mapping(address=>Kurs) public  kurslar;
    mapping(address=>KamuKurumu) public kamuKurumlari;
    mapping(address=>STK) public stklar;
    mapping(address=>SertifikaMerkezi) public sertifikaMerkezleri;

     mapping(uint32=>YabanciDil) public diller;
}