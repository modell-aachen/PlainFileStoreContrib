use strict;
use warnings;

use utf8;

package PlainFileStoreContribTests;

use FoswikiFnTestCase;
our @ISA = qw( FoswikiFnTestCase );

use Foswiki;
use File::Slurp;

sub new {
    my $self = shift()->SUPER::new(@_);
    return $self;
}

# Set up the test fixture
sub set_up {
    my $this = shift;

    $this->SUPER::set_up();
}

sub tear_down {
    my $this = shift;
    $this->SUPER::tear_down();
}


sub test_save_topic_creates_file_and_history {
    my $this = shift;
    my $store = Foswiki::Store::PlainFile->new();

    my $testTopicName = "TestTopic";
    my $testUserCUID = "TestUser";
    my $topicText = "Blub";

    my $meta = Foswiki::Meta->new($this->{session}, $this->{test_web}, $testTopicName, $topicText);
    $store->saveTopic($meta, $testUserCUID);

    my $testFileName = File::Spec->catdir($Foswiki::cfg{DataDir},$this->{test_web},"$testTopicName.txt");
    $this->assert(-e $testFileName,"File for saved topic does not exist.");
    my $historyDir = File::Spec->catdir($Foswiki::cfg{DataDir},$this->{test_web},"$testTopicName,pfv");
    $this->assert(-d $historyDir,"History folder for saved topic does not exist.");

    my $fileText = File::Slurp::read_file($testFileName, binmode => ':utf8');
    $this->assert_str_equals($topicText, $fileText, "The written topic text is not correct.");

    my $topicMetaFileName = File::Spec->catdir($historyDir, "1.m");
    $this->assert(-e $topicMetaFileName,"File for meta data does not exist.");

    my $topicMetaFileText = File::Slurp::read_file($topicMetaFileName, binmode => ':utf8');
    $this->assert_str_equals($testUserCUID."\n", $topicMetaFileText, "The user CUID in the meta file is not correct.");
}

sub test_save_topic_with_special_characters {
    my $this = shift;
    my $store = Foswiki::Store::PlainFile->new();

    my $testTopicName = "🐵 🙈 🙉 🙊";
    my $testUserCUID = "🐵 🙈";
    my $topicText = "(╯°□°）╯︵ ┻━┻)";

    my $meta = Foswiki::Meta->new($this->{session}, $this->{test_web}, $testTopicName, $topicText);
    $store->saveTopic($meta, $testUserCUID);

    my $testFileName = File::Spec->catdir($Foswiki::cfg{DataDir},$this->{test_web},"$testTopicName.txt");
    $this->assert(-e $testFileName,"File for saved topic does not exist.");

    my $fileText = File::Slurp::read_file($testFileName, binmode => ':utf8');
    $this->assert_str_equals($topicText, $fileText, "The written topic text is not correct.");
}


1;
