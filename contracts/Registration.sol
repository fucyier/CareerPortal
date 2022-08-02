// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./EgitimBilgileri.sol";
import "./YabanciDilBilgileri.sol";

contract Registration{
  address YOK;
  address TOBB;
  address CB;
    EgitimBilgileri egitimBilgileri;

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
    
    struct  Person
    {
      bool status;
      EgitimBilgileri.EducationInfo[] educations;
      YabanciDilBilgileri.YabanciDil[] yabanciDiller;
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



 
       mapping(address=>Universite) public universities;
      mapping(address=>Akademisyen) public academicians;
    mapping(address=>Company) public  companies;
    mapping(address=>Course) public  courses;
    mapping(address=>PublicInstitution) public publicInstitutions;
    mapping(address=>NGO) public ngos;
    mapping(address=>Person) public people;


    event PersonRegisteredLog(address _personAddress);
   event AcademicianRegisteredLog(address _academicianAddress,address _universityAddress, bytes32  _name,bytes32  _surname,uint16  _bolum,Unvan _unvan);
  event UniversityRegisteredLog(address _universityAddress,bytes32  _name, uint8 _country);
    event CompanyRegisteredLog(address _companyAddress,bytes32  _name, uint _identityNumber,bytes32  _country);
    event PublicInstitutionRegisteredLog(address _institutionAddress,bytes32  _name,bytes32  _country);
    event NGORegisteredLog(address _ngoAddress,bytes32  _name,bytes32  _country);
    event CourseRegisteredLog(address _courseAddress,bytes32  _name,bytes32  _country);
  event YabanciDilEklendiLog(address _onaylayanKurumTipi,address _onayKurum, uint _basTarih, uint _bitTarih,EgitimBilgileri.OgretimTipi _ogretimTipi,uint32 _ogretimDili);
    constructor (address _yok, address _tobb, address _cb){
        YOK=_yok;
        TOBB=_tobb;
        CB=_cb;
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
      require(universities[msg.sender].status,
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
      require(universities[msg.sender].status||companies[msg.sender].status||publicInstitutions[msg.sender].status,
      "Bu islemi sadece Kurs yapabilir."
      );
      _;
    } 
      modifier onlyOwner {
      require(msg.sender == address(this),
      "Bu islemi sadece kontrat sahibi yapabilir");
      _;
   }
     function isPerson(address _address) public view returns(bool){
        return people[_address].status;
    }

      function isCompany(address _address) public view returns(bool){
        return companies[_address].status;
    }
      function isPublicInstitution(address _address) public view returns(bool){
        return publicInstitutions[_address].status;
    }

      function isCourse(address _address) public view returns(bool){
        return courses[_address].status;
    }
       function isNGO(address _address) public view returns(bool){
        return ngos[_address].status;
    }
 function registerUniversity(address _universityAddress,bytes32 _name, uint8 _country)  public onlyYOK{
        require(!universities[_universityAddress].status,
            "Universite zaten mevcut"
            );
        universities[_universityAddress]=Universite(true,_isim, _ulke);
  emit UniversityRegisteredLog( _universityAddress, _isim, _ulke);
    }
  function registerStudent(address _studentAddress,EgitimBilgileri.EducationInfo memory _egitimBilgileri)   public onlyUniversity{
        require(!people[_studentAddress].status,
            "Student exists already"
            );
            
        people[_studentAddress].status=true;
        people[_studentAddress].educations.push(_egitimBilgileri) ;

        emit PersonRegisteredLog( _studentAddress);
    }
    function addYabanciDil(address _studentAddress,YabanciDilBilgileri.YabanciDil memory _ydBilgi)   public Only_Uni_Comp_Publ{
       require(people[_studentAddress].status,
            "Student not exists"
            );
     
        people[_studentAddress].yabanciDiller.push(_ydBilgi) ;

        emit YabanciDilEklendiLog(_ydBilgi.onayKurumTipi, _ydBilgi.onayKurum,  _ydBilgi.basTarih,  _ydBilgi.bitTarih, _ydBilgi.ogretimTipi, _ydBilgi.ogretimDili);
    }
     function registerAcademician(address _academicianAddress,address _universityAddress, bytes32 _name, bytes32 _surname,uint16 _bolum, EgitimBilgileri.Unvan _unvan)   public onlyUniversity{
        require(!academicians[_academicianAddress].status,
            "Academician exists already"
            );

       academicians[_academicianAddress]=Akademisyen( true,_universityAddress, _bolum,  _unvan,  _name,  _surname);
       emit AcademicianRegisteredLog( _academicianAddress,_universityAddress,  _name,  _surname,  _bolum, _unvan);

    }
  function registerCompany(address _companyAddress,bytes32 _name, uint _identityNumber,bytes32 _country) 
  public onlyTOBB{
        require(!companies[_companyAddress].status,
            "Company exists already"
            );
            
        companies[_companyAddress].status=true;
        companies[_companyAddress].name=_name;
        companies[_companyAddress].country=_country;
        companies[_companyAddress].identityNumber=_identityNumber;

        emit CompanyRegisteredLog( _companyAddress,  _name,  _identityNumber,  _country);
       
    }
     function registerPublicInstitution(address _institutionAddress,bytes32 _name, bytes32 _country) 
     public onlyCB{
        require(!publicInstitutions[_institutionAddress].status,
            "Public Institution exists already"
            );
            
        publicInstitutions[_institutionAddress].status=true;
        publicInstitutions[_institutionAddress].name=_name;
        publicInstitutions[_institutionAddress].country=_country;

        emit PublicInstitutionRegisteredLog( _institutionAddress,  _name, _country);
       
    }
     function registerCourse(address _courseAddress,bytes32 _name, bytes32 _country) 
     public Only_Uni_Comp_Publ{
        require(!courses[_courseAddress].status,
            "Public Institution exists already"
            );
            
        courses[_courseAddress].status=true;
        courses[_courseAddress].name=_name;
        courses[_courseAddress].country=_country;
        
        emit CourseRegisteredLog( _courseAddress,  _name, _country);
       
    }
     function registerNGO(address _ngoAddress,bytes32 _name, bytes32 _country) 
     public onlyOwner{
        require(!ngos[_ngoAddress].status,
            "Public Institution exists already"
            );
            
        courses[_ngoAddress].status=true;
        courses[_ngoAddress].name=_name;
        courses[_ngoAddress].country=_country;
        
        emit NGORegisteredLog( _ngoAddress,  _name, _country);
       
    }
}

