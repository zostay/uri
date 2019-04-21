use v6;

use Test;
use URI;

lives-ok {
    my $u = URI.new(uri => '');
    ok $u.defined, 'empty URI is not very useful, but ok';
    CONTROL { die "a warning occurred: $_" }
};

done-testing;
