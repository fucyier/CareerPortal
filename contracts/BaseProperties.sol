// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
abstract contract BaseProperties{

  struct  Kisi
    {
      bool durum;
    
    }
   enum EgitimDurumu { 
             Lisans, 
             OnLisans, 
             YuksekLisans,
             Doktora }

         enum OgretimTipi { 
             OrgunOgretim, 
             AcikOgretim, 
             IkinciOgretim,
             UzaktanOgretim }
             
                enum CalismaTipi { 
             YariZamanli, 
             TamZamanli, 
             Stajyer
             }

    struct Onay{
      uint zaman;
      address adres;
      OnayDurum durum;
    }
     enum OnayDurum {
        OnayBekliyor,
        Onaylandi,
        Reddedildi
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
        enum Cinsiyet{Erkek,Kadin}
        enum AskerlikDurum{Yapildi,Tecilli,Yapiliyor}
        enum EhliyetDurum{Yok,A,B,C,D,E}
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
     struct Ulke
    {
        uint8 id;
        string isim;
    }

    



}