// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract BaseContract{
     address YOK;
  address TOBB;
  address CB;
struct  Person
    {
      bool status;
    
    }
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
  enum OnaylayanKurum { 
             Universite, 
             Firma, 
             Kamu,
             STK,
             SertifikaMerkezi }
     struct Company
    {
      bool status;
      bytes32 country;
      uint identityNumber;
      bytes32 name;
    }
     struct PublicInstitution
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
      struct NGO
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
    struct Course
    {
      bool status;
      bytes32 name;
      bytes32 country;
    }
      modifier onlyYOK{
      require(msg.sender == YOK,
      "Sadece YOK bu islemi yapabilir."
      );
      _;
     }    
    
      modifier onlyTOBB{
      require(msg.sender == TOBB,
      "Sadece TOBB bu islemi yapabilir."
      );
      _;
     }

      modifier onlyCB{
      require(msg.sender == CB,
      "Sadece CB bu islemi yapabilir."
      );
      _;
    }    

      modifier onlyUniversity{
      require(universities[msg.sender].durum,
      "Sadece Universite bu islemi yapabilir."
      );
      _;
    } 

      modifier onlyCourse{
      require(courses[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 

      modifier Only_Uni_Comp_Publ{
      require(universities[msg.sender].durum||companies[msg.sender].status||publicInstitutions[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
      modifier onlyOwner {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir"
      );
      _;
    }


    mapping(address=>Person) public people;
    mapping(address=>Universite) public universities;
    mapping(address=>Akademisyen) public academicians;
    mapping(address=>Company) public  companies;
    mapping(address=>Course) public  courses;
    mapping(address=>PublicInstitution) public publicInstitutions;
    mapping(address=>NGO) public ngos;
}