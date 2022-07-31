// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract EgitimBilgileri{

 event AcademicianRegisteredLog(address _academicianAddress,address _universityAddress, bytes32  _name,bytes32  _surname,uint16  _bolum,Unvan _unvan);
  event UniversityRegisteredLog(address _universityAddress,bytes32  _name, uint8 _country);


    struct EducationInfo {
         EgitimDurumu egitimDurumu;
         uint basTarih;
         uint bitTarih;
         uint8 diplomaNotu;
         bytes32 diplomaBelge;
         bytes32 transcriptBelge;
         address universite;
         uint16 fakulte;
         uint16 bolum;
         OgretimTipi ogretimTipi;
         uint32 ogretimDili;
         uint8 ulke;
         uint32 sehir;
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

        struct Universite
        {
        bool durum;
        bytes32 isim;
        uint8 ulke;
        }

        struct Akademisyen
        {
        bool durum;
        address universite;
        uint16 bolum;
        Unvan unvan; 
        bytes32 name;
        bytes32 surname;
        }

          enum Unvan { DR, AS_PROF, PROF,MD } 

     mapping(address=>Universite) public universities;
     mapping(address=>Akademisyen) public academicians;
    function isUniversity(address _address) public view returns(bool){
        return universities[_address].durum;
    }
      function isAcademician(address _address) public view returns(bool){
        return academicians[_address].durum;
   }
    function addUniversite (address _universityAddress, bytes32 _isim, uint8 _ulke) public {
        universities[_universityAddress] = Universite(true,_isim, _ulke);
            emit UniversityRegisteredLog( _universityAddress, _isim, _ulke);
          
    }

        function addAcademician (address _academicianAddress,address _universityAddress, bytes32 _name, bytes32 _surname,uint16 _bolum, Unvan _unvan) public {
        academicians[_universityAddress] = Akademisyen(true,_universityAddress,_bolum,_unvan,_name, _surname);
           emit AcademicianRegisteredLog( _academicianAddress,_universityAddress,  _name,  _surname,  _bolum, _unvan);
    }
}