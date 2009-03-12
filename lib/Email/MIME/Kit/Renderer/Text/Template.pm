package Email::MIME::Kit::Renderer::Text::Template;
use Moose;
with 'Email::MIME::Kit::Role::Renderer';
# ABSTRACT: render parts of your mail with Text::Template

use Text::Template ();

sub _enref_as_needed {
  my ($self, $hash) = @_;

  my %return;
  while (my ($k, $v) = each %$hash) {
    $return{ $k } = (ref $v and not blessed $v) ? $v : \$v;
  }

  return \%return;
}

has template_args => (
  is  => 'ro',
  isa => 'HashRef',
);

sub render  {
  my ($self, $input_ref, $args)= @_;

  my $hash = $self->_enref_as_needed({
    (map {; $_ => ref $args->{$_} ? $args->{$_} : \$args->{$_} } keys %$args),
  });

  my $result = Text::Template::fill_in_string(
    $$input_ref,
    %{ $self->{template_args} || {} },
    HASH => $hash,
  );

  return \$result;
}

1;
