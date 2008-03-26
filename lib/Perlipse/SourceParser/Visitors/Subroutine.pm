package Perlipse::SourceParser::Visitors::Subroutine;

use strict;

use Perlipse::SourceParser::Utils;

my $utils = 'Perlipse::SourceParser::Utils';

sub accepts
{
    my $class = shift;
    my ($element) = @_;

    return ($element->class eq 'PPI::Statement::Sub');
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

    if ($element->forward)
    {
        $node->sourceEnd($utils->lastLocation($element));
    }
    elsif ($element->block)
    {
        my $finish = $element->block->finish;
        if ($finish)
        {
            $node->sourceEnd($utils->location($finish));
        }
        else
        {
            #print STDERR "missing closing }\n";
        }
    }
    else
    {
        # print STDERR "subroutine has no block or forward declaration";
    }

    if (!defined $ast->curPkg)
    {
        $ast->curPkg(_createMain($ast));
    }

    $ast->curPkg->addStatement($node);

    return 1;
}

sub _createMain
{
    return shift->createNode(
        type        => 'PPI::Statement::Package',
        name        => 'main',
        nStart   => 0,
        nEnd     => 0,
        sStart => 0,
    );
}

1;
