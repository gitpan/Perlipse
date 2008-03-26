package Perlipse::SourceParser::VisitorDelegate;

use strict;
use fields qw(cache);

use Module::Pluggable
  require     => 1,
  search_path => ['Perlipse::SourceParser::Visitors'];

sub new
{
    my $class = shift;
    my $self  = fields::new($class);

    $self->{cache} = {};

    return $self;
}

sub endVisit
{
    my $self = shift;
}

sub visit
{
    my $self = shift;
    my ($element, $ast) = @_;

    my $visitor = _find_visitor($self, $element);

    if ($visitor)
    {
        return $visitor->visit($element, $ast);
    }

    return;
}

sub _find_visitor
{
    my $self = shift;
    my ($element) = @_;

    my $class = $element->class;

    if (!exists $self->{cache}->{$class})
    {
        foreach my $plugin ($self->plugins)
        {
            if (!$plugin->accepts($element))
            {
                next;
            }

            $self->{cache}->{$class} = $plugin;
            last;
        }
    }

    return $self->{cache}->{$class};
}

1;
