use ExtUtils::MakeMaker;

WriteMakefile
 (NAME     => "Math::Zap",
  VERSION  => "1.05",	
  ABSTRACT => "Draw 3D objects in 2D",
  AUTHOR   => "philiprbrenan@yahoo.com",
  PREREQ_PM=> 
   {Tk           => 0,
    Math::Trig   => 0,
    Test::Simple => 0,
   }
 );
