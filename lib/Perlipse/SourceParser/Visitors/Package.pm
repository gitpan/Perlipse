package Perlipse::SourceParser::Visitors::Package;

use strict;

sub accepts
{
    my $class = shift;
    my ($element) = @_;
    
    return ($element->class eq 'PPI::Statement::Package'); 
}

sub endVisit
{
    my $class = shift;

}

sub visit
{
    my $class = shift;
    my ($element, $ast) = @_;
    
    my $node = $ast->createNode(element => $element);
    
    if (defined $ast->curPkg)
    {
        my $sEnd = $node->sourceStart() - 1;
        $ast->curPkg->sourceEnd($sEnd);
    }

    $ast->curPkg($node);
    $ast->addPkg($node);
    
    return 1;
}

1;